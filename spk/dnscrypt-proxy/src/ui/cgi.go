// HTML user interface for dnscrypt-proxy
// Copyright Sebastian Schmidt
// Licence MIT
package main

import (
    "bytes"
    "encoding/json"
    "errors"
    "flag"
    "fmt"
    "html/template"
    "io/ioutil"
    "net/url"
    "os"
    "os/exec"
    "regexp"
    "strings"
)

var dev *bool
var rootDir string
var files map[string]string

// Page contains the data that is passed to the template (layout.html)
type Page struct {
    Title          string
    FileData       string
    ErrorMessage   string
    SuccessMessage string
    File           string
    Files          map[string]string
}

// AppPrivilege is part of AuthJSON
type AppPrivilege struct {
    IsPermitted bool `json:"SYNO.SDS.DNSCryptProxy.Application"`
}

// Session is part of AuthJSON
type Session struct {
    IsAdmin bool `json:"is_admin"`
}

// AuthJSON is used to read JSON data from /usr/syno/synoman/webman/initdata.cgi
type AuthJSON struct {
    Session      Session `json:"session"`
    AppPrivilege AppPrivilege
}

// Retrieve login status and try to retrieve a CSRF token.
// If either fails than we return an error to the user that they need to login.
// Returns username or error
func token() (string, error) {
    cmd := exec.Command("/usr/syno/synoman/webman/login.cgi")
    cmdOut, err := cmd.Output()
    if err != nil && err.Error() != "exit status 255" { // in the Synology world, error code 255 apparently means success!
        return string(cmdOut), err
    }
    // cmdOut = bytes.TrimLeftFunc(cmdOut, findJSON)

    // Content-Type: text/html [..] { "SynoToken" : "GqHdJil0ZmlhE", "result" : "success", "success" : true }
    r, err := regexp.Compile("SynoToken\" *: *\"([^\"]+)\"")
    if err != nil {
        return string(cmdOut), err
    }
    token := r.FindSubmatch(cmdOut)
    if len(token) < 1 {
        return string(cmdOut), errors.New("Sorry, you need to login first!")
    }
    return string(token[1]), nil
}

// Detect if the rune (character) contains '{' and therefore is likely to contain JSON
// returns bool
func findJSON(r rune) bool {
    if r == '{' {
        return false
    }
    return true
}

// Check if the logged in user is Authorised or Admin.
// If either fails than we return a HTTP Unauthorized error.
func auth() {
    token, err := token()
    if err != nil {
        logUnauthorised(err.Error())
    }

    // X-SYNO-TOKEN:9WuK4Cf50Vw7Q
    // http://192.168.1.1:5000/webman/3rdparty/DownloadStation/webUI/downloadman.cgi?SynoToken=9WuK4Cf50Vw7Q
    tempQueryEnv := os.Getenv("QUERY_STRING")
    os.Setenv("QUERY_STRING", "SynoToken="+token)
    cmd := exec.Command("/usr/syno/synoman/webman/modules/authenticate.cgi")
    user, err := cmd.Output()
    if err != nil && string(user) == "" {
        logUnauthorised(err.Error())
    }

    // check permissions
    cmd = exec.Command("/usr/syno/synoman/webman/initdata.cgi") // performance hit
    cmdOut, err := cmd.Output()
    if err != nil {
        logUnauthorised(err.Error())
    }
    cmdOut = bytes.TrimLeftFunc(cmdOut, findJSON)

    var jsonData AuthJSON
    if err := json.Unmarshal(cmdOut, &jsonData); err != nil {  // performance hit
        logUnauthorised(err.Error())
    }

    isAdmin := jsonData.Session.IsAdmin              // Session.IsAdmin:true
    isPermitted := jsonData.AppPrivilege.IsPermitted // AppPrivilege.SYNO.SDS.DNSCryptProxy.Application:true
    if !(isAdmin || isPermitted) {
        notFound()
    }

    os.Setenv("QUERY_STRING", tempQueryEnv)
    return
}

// Exit program with a HTTP Internal Error status code and a message (dump and die)
func logError(str ...string) {
    fmt.Println("Status: 500 Internal server error\nContent-Type: text/html; charset=utf-8\n")
    fmt.Println(strings.Join(str, ", "))
    os.Exit(0)
}

// Exit program with a HTTP Unauthorized status code and a message (dump and die)
func logUnauthorised(str ...string) { // dump and die
    fmt.Println("Status: 401 Unauthorized\nContent-Type: text/html; charset=utf-8\n")
    fmt.Println(strings.Join(str, ", "))
    os.Exit(0)
}

// Exit program with a HTTP Not Found status code
func notFound() {
    fmt.Println("Status: 404 Not Found\nContent-Type: text/html; charset=utf-8\n")
    os.Exit(0)
}

// Return true if the file path exists.
func checkIfFileExists (file string) bool {
    _, err := os.Stat(file)
    if err != nil {
        if os.IsNotExist(err) {
            return false
        }
        logError(err.Error())
    }
    return true
}

// Read file from filepath and return the data as a string
func loadFile(file string) string {
    if !checkIfFileExists(file) {
        newFile, err := os.Create(file)
        if err != nil {
            logError(err.Error())
        }
        newFile.Close()
    }

    data, err := ioutil.ReadFile(file)
    if err != nil {
        logError(err.Error())
    }
    return string(data)
}

// Save file content (data) to the approved file path (fileKey)
func saveFile(fileKey string, data string) {
    err := ioutil.WriteFile(rootDir+files[fileKey]+".tmp", []byte(data), 0644)
    if err != nil {
        logError(err.Error())
    }

    if fileKey == "config" {
        checkConfFile(true)
    }

    err = os.Rename(rootDir+files[fileKey]+".tmp", rootDir+files[fileKey]) // atomic
    if err != nil {
        logError(err.Error())
    }

    if fileKey != "config" {
        checkConfFile(false)
    }

    return
}

// Check the config file for syntax errors
func checkConfFile(tmp bool) {
    var tmpExt string
    if tmp {
        tmpExt = ".tmp"
    }

    cmd := exec.Command(rootDir+"/bin/dnscrypt-proxy", "-check", "-config", rootDir+files["config"]+tmpExt)
    out, err := cmd.CombinedOutput()
    if err != nil {
        renderHTML("config", "", string(out)+err.Error())
    }
}

// Look for command in $PATH
func checkCmdExists(cmd string) bool {
    _, err := exec.LookPath(cmd)
    if err != nil {
        return false
    }
    return true
}

// Execute generate-domains-blacklist.py to generate blacklist.txt
func generateBlacklist () {
    if !checkCmdExists("python") {
        fmt.Println("Status: 500 OK\nContent-Type: text/plain; charset=utf-8\n")
        fmt.Println("Python could not be found or is not installed!")
        os.Exit(0)
    }

    var stdout, stderr bytes.Buffer
    cmd := exec.Command("python", rootDir+"/var/generate-domains-blacklist.py")
    cmd.Dir = rootDir+"/var"
    cmd.Stdout = &stdout
    cmd.Stderr = &stderr
    err := cmd.Run()
    if err != nil {
        fmt.Println("Status: 500 OK\nContent-Type: text/plain; charset=utf-8\n")
        fmt.Println(string(stderr.Bytes())+err.Error())
        os.Exit(0)
    }
    saveFile("blacklist", string(stdout.Bytes()))
}

// Return HTML from layout.html.
func renderHTML(fileKey string, successMessage string, errorMessage string) {
    var page Page
    fileData := loadFile(rootDir + files[fileKey])

    tmpl, err := template.ParseFiles("layout.html")
    if err != nil {
        logError(err.Error())
    }

    page.Title = "DNSCrypt-proxy"
    page.File = fileKey
    page.Files = files
    page.FileData = fileData
    page.ErrorMessage = errorMessage
    page.SuccessMessage = successMessage
    fmt.Println("Status: 200 OK\nContent-Type: text/html; charset=utf-8\n")
    err = tmpl.Execute(os.Stdout, page)
    if err != nil {
        logError(err.Error())
    }
    os.Exit(0)
}

// Read GET parameters and return them as an Object
func readGet() url.Values {
    queryStr := os.Getenv("QUERY_STRING")
    q, err := url.ParseQuery(queryStr)
    if err != nil {
        logError(err.Error())
    }
    return q
}

// Read POST parameters and return them as an Object
func readPost() url.Values { // todo: stop on a max size (10mb?)
    // fixme: check/generate csrf token
    bytes, err := ioutil.ReadAll(os.Stdin) // if there is no data the process will block (wait)
    if err != nil {
        logError(err.Error())
    }

    q, err := url.ParseQuery(string(bytes))
    if err != nil {
        logError(err.Error())
    }
    return q
}

func main() {
    // Todo:
    // fix-up error handling with correct http responses (add --debug flag?/Synology's notifications?)
    // worry about csrf

    dev = flag.Bool("dev", false, "Turns Authentication checks off")
    flag.Parse()

    if *dev { // test environment
        pwd, err := os.Getwd()
        if err != nil {
            fmt.Println(err)
            os.Exit(1)
        }
        rootDir = pwd+"/test"
    } else { // production environment
        auth()
        rootDir = "/var/packages/dnscrypt-proxy/target"
    }

    files = make(map[string]string)
    files["config"] = "/var/dnscrypt-proxy.toml"
    files["blacklist"] = "/var/blacklist.txt"
    files["ip-blacklist"] = "/var/ip-blacklist.txt"
    files["cloaking"] = "/var/cloaking-rules.txt"
    files["forwarding"] = "/var/forwarding-rules.txt"
    files["whitelist"] = "/var/whitelist.txt"
    files["-domains-blacklist"] = "/var/domains-blacklist.conf" // - is used for ordering
    files["-domains-whitelist"] = "/var/domains-whitelist.txt"
    files["-domains-time-restricted"] = "/var/domains-time-restricted.txt"
    files["-domains-blacklist-local-additions"] = "/var/domains-blacklist-local-additions.txt"

    method := os.Getenv("REQUEST_METHOD")
    if method == "POST" || method == "PUT" || method == "PATCH" { // POST
        postData := readPost()
        fileData := postData.Get("fileContent")
        fileKey := postData.Get("file")
        generateBlacklistStr := postData.Get("generateBlacklist")
        if fileData != "" && fileKey != "" {
            saveFile(fileKey, fileData)
            renderHTML(fileKey, "File saved successfully!", "")
            // fmt.Println("Status: 200 OK\nContent-Type: text/plain;\n")
            // return
        } else if generateBlacklistStr != "" {
            generateBlacklist()
            fmt.Println("Status: 200 OK\nContent-Type: text/plain; charset=utf-8\n")
            os.Exit(0)
        }
        renderHTML("config", "", "No valid data submitted.")
    }

    if fileKey := readGet().Get("file"); method == "GET" && fileKey != "" { // GET
        renderHTML(fileKey, "", "")
    }

    renderHTML("config", "", "")
}

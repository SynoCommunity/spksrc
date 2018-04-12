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

type Page struct {
    Title          string
    FileData       string
    ErrorMessage   string
    SuccessMessage string
    File           string
    Files          map[string]string
}

type AppPrivilege struct {
    Is_permitted bool `json:"SYNO.SDS.DNSCryptProxy.Application"`
}
type Session struct {
    Is_admin bool `json:"is_admin"`
}
type AuthJson struct {
    Session      Session `json:"session"`
    AppPrivilege AppPrivilege
}

func token() (string, error) {
    cmd := exec.Command("/usr/syno/synoman/webman/login.cgi")
    cmdOut, err := cmd.Output()
    if err != nil && err.Error() != "exit status 255" { // in the Synology world, error code 255 apparently means success!
        return string(cmdOut), err
    }
    // cmdOut = bytes.TrimLeftFunc(cmdOut, findJson)

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

func findJson(r rune) bool {
    if r == '{' {
        return false
    }
    return true
}

func auth() string {
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
    cmdOut = bytes.TrimLeftFunc(cmdOut, findJson)

    var jsonData AuthJson
    if err := json.Unmarshal(cmdOut, &jsonData); err != nil {  // performance hit
        logUnauthorised(err.Error())
    }

    is_admin := jsonData.Session.Is_admin              // Session.is_admin:true
    is_permitted := jsonData.AppPrivilege.Is_permitted // AppPrivilege.SYNO.SDS.DNSCryptProxy.Application:true
    if !(is_admin || is_permitted) {
        notFound()
    }

    os.Setenv("QUERY_STRING", tempQueryEnv)
    return string(cmdOut)
}

func logError(str ...string) { // dump and die
    fmt.Println("Status: 500 Internal server error\nContent-Type: text/html; charset=utf-8\n")
    fmt.Println(strings.Join(str, ", "))
    os.Exit(0)
}

func logUnauthorised(str ...string) { // dump and die
    fmt.Println("Status: 401 Unauthorized\nContent-Type: text/html; charset=utf-8\n")
    fmt.Println(strings.Join(str, ", "))
    os.Exit(0)
}

func notFound() {
    fmt.Println("Status: 404 Not Found\nContent-Type: text/html; charset=utf-8\n")
    os.Exit(0)
}

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

func checkConfFile(tmp bool) {
    var tmpExt string
    if tmp {
        tmpExt = ".tmp"
    }

    cmd := exec.Command(rootDir+"/bin/dnscrypt-proxy", "-check", "-config", rootDir+files["config"]+tmpExt)
    out, err := cmd.CombinedOutput()
    if err != nil {
        renderHtml("config", "", string(out)+err.Error())
    }
}

func checkCmdExists(cmd string) bool {
    _, err := exec.LookPath(cmd)
    if err != nil {
        return false
    }
    return true
}

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

func renderHtml(fileKey string, successMessage string, errorMessage string) {
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

func readGet() url.Values {
    queryStr := os.Getenv("QUERY_STRING")
    q, err := url.ParseQuery(queryStr)
    if err != nil {
        logError(err.Error())
    }
    return q
}

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

    pwd, err := os.Getwd()
    if err != nil {
        fmt.Println(err)
        os.Exit(1)
    }
    rootDir = pwd+"/test"

    if !*dev {
        auth()
        rootDir = "/var/packages/dnscrypt-proxy/target"
    }

    files = make(map[string]string)
    files["config"] = "/var/dnscrypt-proxy.toml"
    files["blacklist"] = "/var/blacklist.txt"
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
            renderHtml(fileKey, "File saved successfully!", "")
            // fmt.Println("Status: 200 OK\nContent-Type: text/plain;\n")
            // return
        } else if generateBlacklistStr != "" {
            generateBlacklist()
            fmt.Println("Status: 200 OK\nContent-Type: text/plain; charset=utf-8\n")
            os.Exit(0)

        }
        renderHtml("config", "", "No valid data submitted.")
    }

    if fileKey := readGet().Get("file"); method == "GET" && fileKey != "" { // GET
        renderHtml(fileKey, "", "")
    }

    renderHtml("config", "", "")
}

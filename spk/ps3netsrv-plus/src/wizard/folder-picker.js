{
  var step = arguments[0]
  var wizard = arguments[1]
  var shareField = step.getComponent('wizard_shared_folder_name')
  var pathField = step.getComponent('wizard_library_subdir')
  var picker = document.getElementById('ps3netsrv-folder-picker')
  if (!shareField || !pathField || !picker) return
  if (picker.ps3netsrvState) {
    picker.ps3netsrvState.load(pathField.getValue())
    return
  }
  var shareSelect = document.getElementById('ps3netsrv-share')
  var subdirInput = document.getElementById('ps3netsrv-subdir')
  var upButton = document.getElementById('ps3netsrv-folder-up')
  var currentNode = document.getElementById('ps3netsrv-folder-current')
  var statusNode = document.getElementById('ps3netsrv-folder-status')
  var listNode = document.getElementById('ps3netsrv-folder-list')
  var current = ''
  var requestSerial = 0
  var refreshLayout = function () {
    if (step.doLayout) step.doLayout()
    if (wizard && wizard.doLayout) wizard.doLayout()
  }
  var hideField = function (field) {
    var element = field.getEl && field.getEl()
    var node = element && element.dom
    var item = node && node.closest && node.closest('.x-form-item')
    if (item && !item.contains(picker)) item.style.display = 'none'
    else if (field.hide) field.hide()
  }
  hideField(shareField)
  hideField(pathField)
  subdirInput.value = pathField.getValue()
  refreshLayout()
  var clean = function (value) {
    return String(value || '').trim().replace(/^\/+|\/+$/g, '')
  }
  var status = function (message, failed) {
    statusNode.textContent = message
    statusNode.style.color = failed ? '#c43d3d' : '#536b78'
  }
  var showCurrent = function () {
    var share = shareField.getValue()
    currentNode.textContent = share ? '/' + share + (current ? '/' + current : '') : 'Select a shared folder'
    upButton.disabled = !current
  }
  var render = function (folders) {
    listNode.replaceChildren()
    if (!folders.length) {
      var empty = document.createElement('div')
      empty.textContent = 'No subfolders in this folder.'
      empty.style.padding = '10px'
      empty.style.color = '#637986'
      listNode.appendChild(empty)
      refreshLayout()
      return
    }
    folders.forEach(function (folder) {
      var button = document.createElement('button')
      button.type = 'button'
      button.textContent = folder.name
      button.style.display = 'block'
      button.style.width = '100%'
      button.style.padding = '9px 12px'
      button.style.border = '0'
      button.style.borderBottom = '1px solid #d6dde2'
      button.style.background = '#fff'
      button.style.color = '#243746'
      button.style.textAlign = 'left'
      button.style.cursor = 'pointer'
      button.onclick = function () {
        load(current ? current + '/' + folder.name : folder.name)
      }
      listNode.appendChild(button)
    })
    refreshLayout()
  }
  var load = function (path) {
    var request = ++requestSerial
    var share = shareField.getValue()
    if (!share) {
      current = ''
      listNode.replaceChildren()
      showCurrent()
      status('Select a shared folder first.', true)
      return
    }
    var next = clean(path)
    if (next.split('/').some(function (part) { return part === '..' })) {
      status('The folder must stay inside the selected share.', true)
      return
    }
    current = next
    pathField.setValue(current)
    subdirInput.value = current
    showCurrent()
    status('Loading folders...', false)
    listNode.replaceChildren()
    if (typeof SYNO === 'undefined' || !SYNO.API || !SYNO.API.Request) {
      status('DSM API client is unavailable.', true)
      return
    }
    try {
      SYNO.API.Request({
        api: 'SYNO.FileStation.List',
        version: 2,
        method: 'list',
        appWindow: wizard,
        params: {
          folder_path: '/' + share + (current ? '/' + current : ''),
          offset: 0,
          limit: 1000,
          sort_by: 'name',
          sort_direction: 'ASC',
          filetype: 'dir',
          check_dir: true
        },
        callback: function (success, result, details) {
          if (request !== requestSerial) return
          if (!success) {
            var error = result && (result.error || result)
            var code = error && error.code
            if (!code && details && details.code) code = details.code
            status('Unable to browse this folder: DSM API error ' + (code || 'unknown'), true)
            return
          }
          var folders = (result && result.files || []).filter(function (entry) { return entry.isdir })
          render(folders)
          status(folders.length + (folders.length === 1 ? ' folder' : ' folders'), false)
        }
      })
    } catch (error) {
      if (request === requestSerial) status('Unable to browse this folder: ' + error.message, true)
    }
  }
  upButton.onclick = function () {
    var parts = current.split('/').filter(Boolean)
    parts.pop()
    load(parts.join('/'))
  }
  shareSelect.onchange = function () {
    shareField.setValue(shareSelect.value)
    pathField.setValue('')
    subdirInput.value = ''
    current = ''
    load('')
  }
  subdirInput.oninput = function () {
    pathField.setValue(subdirInput.value)
  }
  subdirInput.onchange = function () {
    load(subdirInput.value)
  }
  var shareStore = shareField.getStore && shareField.getStore()
  var populateShares = function () {
    var selected = shareField.getValue()
    shareSelect.replaceChildren()
    if (shareStore && shareStore.each) {
      shareStore.each(function (record) {
        var value = record.get ? record.get('name') : record.name
        if (!value) return
        var option = document.createElement('option')
        option.value = value
        option.textContent = value
        shareSelect.appendChild(option)
        if (!selected) selected = value
      })
    }
    if (selected) {
      shareField.setValue(selected)
      shareSelect.value = selected
      load(subdirInput.value)
    } else {
      load('')
    }
  }
  if (shareStore && shareStore.on) shareStore.on('load', populateShares)
  if (shareStore && shareStore.getCount && shareStore.getCount()) populateShares()
  else if (shareStore && shareStore.load) shareStore.load()
  else load('')
  picker.ps3netsrvState = {load: function (path) {
    subdirInput.value = path
    load(path)
  }}
}

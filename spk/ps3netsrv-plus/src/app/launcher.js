(function () {
  SYNO.namespace('SYNO.SDS.ps3netsrvplus')

  SYNO.SDS.ps3netsrvplus.Utils = {
    managerURL: function () {
      const base = '/webman/3rdparty/ps3netsrv-plus/index.html'
      const token = window.PS3NETSRV_PLUS_SYNO_TOKEN || ''
      const rev = window.PS3NETSRV_PLUS_ASSET_REV || '0'
      return `${base}?rev=${rev}${token ? `&SynoToken=${token}` : ''}`
    }
  }

  SYNO.SDS.ps3netsrvplus.MainWindow = Vue.extend({
    name: 'SYNO.SDS.ps3netsrvplus.MainWindow',
    data: function () {
      return {managerURL: SYNO.SDS.ps3netsrvplus.Utils.managerURL()}
    },
    template: `
      <v-app-instance class-name="SYNO.SDS.ps3netsrvplus.MainWindow">
        <v-app-window
          ref="appWindow"
          syno-id="SYNO.SDS.ps3netsrvplus.Window.v29"
          :resizable="true"
          :maximizable="true"
          :minimizable="true"
          width="1100"
          height="750"
        >
          <iframe
            :src="managerURL"
            style="width:100%; height:100%; border:0; margin:0; padding:0;"
          ></iframe>
        </v-app-window>
      </v-app-instance>
    `
  })

  SYNO.SDS.ps3netsrvplus.Application = Vue.extend({
    name: 'SYNO.SDS.ps3netsrvplus.Application',
    render: function (createElement) {
      return createElement(SYNO.SDS.ps3netsrvplus.MainWindow)
    }
  })
})()

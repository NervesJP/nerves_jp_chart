// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"

let hooks = {}
hooks.chart = {
  mounted() {
    let colors = [
      'rgb(128, 128, 0)',
      'rgb(255, 255, 0)',
      'rgb(255, 0, 255)',
      'rgb(192, 192, 192)',
      'rgb(0, 255, 255)',
      'rgb(0, 255, 0)',
      'rgb(255, 0, 0)',
      'rgb(128, 128, 128)',
      'rgb(0, 0, 255)',
      'rgb(0, 128, 0)',
      'rgb(128, 0, 128)',
      'rgb(0, 0, 0)',
      'rgb(0, 0, 128)',
      'rgb(0, 128, 128)',
      'rgb(128, 0, 0)',
    ]

    var ctx = this.el.getContext('2d');
    new Chart(ctx, {
      // The type of chart we want to create
      type: 'line',
      // The data for our dataset
      data: {
        datasets: []
      },
      // Configuration options go here
      options: {
        scales: {
          xAxes: [{
            type: 'realtime',
            realtime: {
              delay: 2000,
              onRefresh: function(chart) {
                let len_datasets = chart.data.datasets.length;
                let dataEl = document.querySelector('#data');
                let len_users = JSON.parse(dataEl.dataset.users).length;
                for (let i = 0; i < (len_users - len_datasets); i++) {
                  chart.data.datasets.push({borderColor: colors[Math.floor(Math.random() * colors.length)], data: []})
                }

                chart.data.datasets.forEach(function(dataset, index) {
                  dataset.label = JSON.parse(dataEl.dataset.users)[index]
                  dataset.data.push({
                    x: Date.now(),
                    y: JSON.parse(dataEl.dataset.values)[index]
                  });
                });
              }
            }
          }]
        }
      }
    });
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


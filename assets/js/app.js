// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

const org = document.getElementById("org")
const ctx = org.getContext("2d")
const radius = 50
const dx = org.width
const dy = org.height
const offset = 0.2
const center = org.height * .5

console.log(dy*offset)
console.log(dx/2)

ctx.moveTo(dx/2, center)
ctx.lineTo(dx/2, dy/4 )
ctx.stroke()

ctx.moveTo(dx/2, center)
ctx.lineTo(dx/2, dy*.75 )
ctx.stroke()

// ctx.moveTo(dx/2, center)
// ctx.lineTo(dx/2, dy*offset*2.7  )
// ctx.stroke()

// ctx.moveTo(dx/2, center)
// ctx.lineTo(dx/3, dy/2  )
// ctx.stroke()

ctx.beginPath()
ctx.arc(dx/2, center-5, radius, 0, 2*Math.PI)
ctx.fillStyle="blue"
ctx.fill()



// const circ = createCircles(ctx, width/2, org.height * 0.1 + radius)
// createCircles(ctx, width/5*2, org.height * .1 + radius)
// createCircles(ctx, width/5*3, org.height * 0.1 + radius)
// createCircles(ctx, width/5*4, org.height * 0.1 + radius)


function createCircles(ctx, x, y, ) {
    ctx.beginPath()
    ctx.arc(x, y, radius, 0, 2*Math.PI)
    ctx.fill()
    
}


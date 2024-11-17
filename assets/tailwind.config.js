// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/*_web.ex",
    "../lib/*_web/**/*.*ex"
  ],
  theme: {
    extend: {
          colors: {
            background: "var(--background)",
            foreground: "var(--foreground)",
            //Primary
            'primary-900': '#620042',
            'primary-800': '#870557',
            'primary-700': '#A30664',
            'primary-600': '#BC0A6F',
            'primary-500': '#DA127D',
            'primary-400': '#E8368F',
            'primary-300': '#F364A2',
            'primary-200': '#FF8CBA',
            'primary-100': '#FFB8D2',
            'primary-50': '#FFE3EC',
            //Secondary
            'secondary-900': '#102A43',
            'secondary-800': '#243B53',
            'secondary-700': '#334E68',
            'secondary-600': '#486581',
            'secondary-500': '#627D98',
            'secondary-400': '#829AB1',
            'secondary-300': '#9FB3C8',
            'secondary-200': '#BCCCDC',
            'secondary-100': '#D9E2EC',
            'secondary-50': '#F0F4F8',
      // Supporting
            "light-blue-vivid-050": "#E3F8FF",
            "light-blue-vivid-100": "#B3ECFF",
            "light-blue-vivid-200": "#81DEFD",
            "light-blue-vivid-300": "#5ED0FA",
            "light-blue-vivid-400": "#40C3F7",
            "light-blue-vivid-500": "#2BB0ED",
            "light-blue-vivid-600": "#1992D4",
            "light-blue-vivid-700": "#127FBF",
            "light-blue-vivid-800": "#0B69A3",
            "light-blue-vivid-900": "#035388",  
    
            "cyan-050": "#E0FCFF",
            "cyan-100": "#BEF8FD",
            "cyan-200": "#87EAF2",
            "cyan-300": "#54D1DB",
            "cyan-400": "#38BEC9",
            "cyan-500": "#2CB1BC",
            "cyan-600": "#14919B",
            "cyan-700": "#0E7C86",
            "cyan-800": "#0A6C74",
            "cyan-900": "#044E54",  
    
            "red-vivid-050": "#FFE3E3",
            "red-vivid-100": "#FFBDBD",
            "red-vivid-200": "#FF9B9B",
            "red-vivid-300": "#F86A6A",
            "red-vivid-400": "#EF4E4E",
            "red-vivid-500": "#E12D39",
            "red-vivid-600": "#CF1124",
            "red-vivid-700": "#AB091E",
            "red-vivid-800": "#8A041A",
            "red-vivid-900": "#610316",  
    
            "yellow-vivid-050": "#FFFBEA",
            "yellow-vivid-100": "#FFF3C4",
            "yellow-vivid-200": "#FCE588",
            "yellow-vivid-300": "#FADB5F",
            "yellow-vivid-400": "#F7C948",
            "yellow-vivid-500": "#F0B429",
            "yellow-vivid-600": "#DE911D",
            "yellow-vivid-700": "#CB6E17",
            "yellow-vivid-800": "#B44D12",
            "yellow-vivid-900": "#8D2B0B", 
    
            "teal-050": "#EFFCF6",
            "teal-100": "#C6F7E2",
            "teal-200": "#8EEDC7",
            "teal-300": "#65D6AD",
            "teal-400": "#3EBD93",
            "teal-500": "#27AB83",
            "teal-600": "#199473",
            "teal-700": "#147D64",
            "teal-800": "#0C6B58",
            "teal-900": "#014D40",   
    
    
          },
      maxWidth: {
        '3/4': '75%'
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({addVariant}) => addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])),
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function({matchComponents, theme}) {
      let iconsDir = path.join(__dirname, "./vendor/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).map(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = {name, fullPath: path.join(iconsDir, dir, file)}
        })
      })
      matchComponents({
        "hero": ({name, fullPath}) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": theme("spacing.5"),
            "height": theme("spacing.5")
          }
        }
      }, {values})
    })
  ]
}

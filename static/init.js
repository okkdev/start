let theme = ""
if (window.matchMedia("(prefers-color-scheme: dark)").matches) {
  theme = "dark"
} else if (window.matchMedia("(prefers-color-scheme: light)").matches) {
  theme = "light"
}

const app = Elm.Main.init({
  flags: {
    time: Date.now(),
    theme: theme,
  },
})

window
  .matchMedia("(prefers-color-scheme: dark)")
  .addEventListener("change", (e) => {
    app.ports.themeListener.send(e.matches ? "dark" : "light")
  })

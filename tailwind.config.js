module.exports = {
  content: [
    "./app/views/**/*.erb",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js"
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('@themesberg/flowbite/plugin')
  ],
}

module.exports = {
  plugins: [
    require('postcss-nesting'),
    require('postcss-import'),
    require('autoprefixer'),
    require('tailwindcss')({ config: "./tailwind.config.js" }),
  ],
}

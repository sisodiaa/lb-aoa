module.exports = {
  plugins: [
    require('postcss-import'),
    require('tailwindcss/nesting'),
    require('autoprefixer'),
    require('tailwindcss')({ config: "./tailwind.config.js" }),
  ],
}

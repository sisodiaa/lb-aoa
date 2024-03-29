module.exports = {
  content: [
    "./app/views/**/*.erb",
    "./app/components/**/*.erb",
    "./app/components/**/*.rb",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js"
  ],
  theme: {
    backgroundSize: {
      "120%": "120%",
      "150%": "150%",
    },
    backgroundPosition: {
      "100%-75%": "100% 75%",
      "110%-5%": "110% 5%",
    },
    extend: {
      backgroundImage: {
        "homepage": "url('bg-homepage.svg')",
      },
      colors: {
        lb: {
          50:  "#d092c6",
          100: "#c77cbb",
          200: "#be66af",
          300: "#b550a4",
          400: "#ac3a99",
          500: "#a3258e",
          600: "#92217f",
          700: "#821d71",
          800: "#721963",
          900: "#611655",
        },
        "lb-soft": {
          50:  "#e2abd0",
          100: "#dc9ac6",
          200: "#d789bd",
          300: "#d178b3",
          400: "#cb67aa",
          500: "#c657a1",
          600: "#b24e90",
          700: "#9e4580",
          800: "#8a3c70",
          900: "#763460",
        },
        "lb-blue": {
          50:  "#c6ebfc",
          100: "#bbe7fb",
          200: "#afe3fa",
          300: "#a4dffa",
          400: "#99dbf9",
          500: "#8ed8f9",
          600: "#7fc2e0",
          700: "#71acc7",
          800: "#6397ae",
          900: "#558195",
        },
        "lb-green": {
          50:  "#d2e69b",
          100: "#c9e187",
          200: "#c0dc73",
          300: "#b7d75f",
          400: "#aed24b",
          500: "#a6ce38",
          600: "#95b932",
          700: "#84a42c",
          800: "#749027",
          900: "#637b21",
        },
      },
    },
  },
  plugins: [
    require('@themesberg/flowbite/plugin')
  ],
}

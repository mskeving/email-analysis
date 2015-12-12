require("../../css/stats.css")
React       = require("react")
StatDisplay = React.createFactory(require('./StatDisplay.coffee'))

window.onload = ->
  React.render(StatDisplay(), window.document.getElementById('content'))

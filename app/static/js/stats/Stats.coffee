require("../../css/stats.css")
React       = require("react")
StringCount = React.createFactory(require('./StringCount.coffee'))

window.onload = ->
  React.render(StringCount(), window.document.getElementById('content'))

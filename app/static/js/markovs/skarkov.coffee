React          = require("react")
SkarkovDisplay = React.createFactory(require('./SkarkovDisplay.coffee'))

window.onload = ->
  React.render(SkarkovDisplay(), window.document.getElementById('content'))

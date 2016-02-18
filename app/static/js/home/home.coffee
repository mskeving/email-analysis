require("../../stylesheets/home.scss")

React       = require("react")
HomeDisplay = React.createFactory(require('./HomeDisplay.coffee'))

window.onload = ->
  React.render(HomeDisplay(), window.document.getElementById('content'))

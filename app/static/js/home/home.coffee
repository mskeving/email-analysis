React          = require("react")
HomeController = React.createFactory(require('./HomeController.coffee'))

window.onload = ->
  React.render(HomeController(), window.document.getElementById('content'))

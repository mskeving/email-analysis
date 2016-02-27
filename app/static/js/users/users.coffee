React           = require("react")
UsersController = React.createFactory(require('./UsersController.coffee'))

window.onload = ->
  React.render(UsersController(), window.document.getElementById('content'))

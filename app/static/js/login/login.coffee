require('../../stylesheets/login.scss')
React           = require("react")
ReactDom        = require("react-dom")
LoginController = require('./LoginController')

window.onload = ->
  ReactDom.render(React.createElement(LoginController), window.document.getElementById('content'))

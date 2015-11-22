require("../css/stats.css")

React = require("react")
$$    = React.DOM

window.onload = ->
  React.render($$.span(null, "Welcome to the Stats Page"), window.document.getElementById('content'))

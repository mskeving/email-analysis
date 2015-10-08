require("../css/styles.css")
React = require("react")
Markovs = React.createFactory(require('./Markovs.coffee'))

window.onload = ->
  React.render(Markovs(),window.document.getElementById('content'))

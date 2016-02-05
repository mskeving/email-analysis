require("../../stylesheets/skarkov.scss")

React   = require("react")
Markovs = React.createFactory(require('./Markovs.coffee'))

window.onload = ->
  React.render(Markovs(), window.document.getElementById('content'))

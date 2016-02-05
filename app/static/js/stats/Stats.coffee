require("../../stylesheets/stats.scss")
React       = require("react")
StatsController = React.createFactory(require('./StatsController.coffee'))

window.onload = ->
  React.render(StatsController(), window.document.getElementById('content'))

React    = require("react")
TimeLineChart = React.createFactory(require('../common/TimeLineChart.coffee'))

window.onload = ->
  React.render(TimeLineChart(), window.document.getElementById('content'))

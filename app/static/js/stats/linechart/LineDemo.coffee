React   = require('react')
d3      = require('d3')
_       = require('lodash')
$$      = React.DOM

Chart      = React.createFactory(require('./Chart.coffee'))
DataSeries = React.createFactory(require('./DataSeries.coffee'))

module.exports = React.createClass
  displayName: 'LineChart'

  getDefaultProps: ->
    width: 600
    height: 300

  render: ->
    data = @props.data
    size =
      width: @props.width
      height: @props.height

    max = _.chain(data.series1, data.series2, data.series3).zip().map((values) ->
      _.reduce values, ((memo, value) ->
        Math.max memo, value.y
      ), 0
    ).max().value()

    xScale = d3.scale.linear()
      .domain([0, 6])
      .range([0, @props.width])

    yScale = d3.scale.linear()
      .domain([0, max])
      .range([@props.height, 0])

    return Chart
      width: @props.width
      height: @props.height,
      DataSeries
        data: data.series1
        size: size
        xScale: xScale
        yScale: yScale
        ref: "series1"
        color: "cornflowerblue"
      DataSeries
        data: data.series2
        size: size
        xScale: xScale
        yScale: yScale
        ref: "series2"
        color: "red"

'''
make sure data comes in sorted by date, in this format:
    data: [
      { label: 'Name of Person', values: [{x: unix_time_stamp, y: count_for_this_time}] }
      { label: 'Name of Person', values: [{x: unix_time_stamp, y: count_for_this_time}] }
    ]
'''
require("../../css/react-d3-components.css")

React   = require('react')
ReactD3 = require('react-d3-components')
d3      = require('d3')
_       = require('lodash')
$$      = React.DOM
V       = React.PropTypes

LineChart = React.createFactory(ReactD3.LineChart)
Brush     = React.createFactory(ReactD3.Brush)

module.exports = React.createClass
  displayName: 'TimeLineChart'

  propTypes:
    data: V.array.isRequired
    graph_width: V.number

  getDefaultProps: ->
    graph_width: 900
    data: [{
      label: 'One'
      values: [
        {x: new Date(2008, 2, 5), y: 1}
        {x: new Date(2010, 1, 6), y: 2}
      ]
    }
    {
      label: 'Two'
      values: [
        {x: new Date(2009, 2, 5), y: 4}
        {x: new Date(2011, 8, 6), y: 8}
      ]
    }]

  _dates_provided: ->
    data_values = _.flatten(_.pluck(@props.data, 'values'))
    return _.pluck(data_values, 'x')

  _min_date: ->
    return _.min(@_dates_provided())

  _max_date: ->
    return _.max(@_dates_provided())

  getInitialState: ->
    xScaleBrush: d3.time.scale().domain([@_min_date(), @_max_date()]).range([0, @props.graph_width - 70])
    xScale: d3.time.scale().domain([@_min_date(), @_max_date()]).range([0, @props.graph_width - 70])

  _onChange: (extent) ->
    @setState
      xScale: d3.time.scale().domain([extent[0], extent[1]]).range([0, @props.graph_width - 70])

  _tooltip: (label, data) ->
        label + " x: " + data.x + " y: " + data.y

  render: ->
    return $$.div null,
      LineChart
        data: @props.data
        width: @props.graph_width
        height: 400
        margin: {top: 10, bottom: 50, left: 50, right: 20}
        xScale: @state.xScale
        xAxis: {tickValues: @state.xScale.ticks(d3.time.year, 1), tickFormat: d3.time.format("%m/%y")}
        tooltipHtml: @_tooltip
      $$.div
        className: "brush"
        style: { float: "none" },
        Brush
          width: @props.graph_width
          height: 50
          margin: {top: 0, bottom: 30, left: 50, right: 20}
          xScale: @state.xScaleBrush
          extent: [@_min_date(), @_max_date()]
          onChange: @_onChange
          xAxis: {tickValues: @state.xScaleBrush.ticks(d3.time.year, 1), tickFormat: d3.time.format("%m/%y")}

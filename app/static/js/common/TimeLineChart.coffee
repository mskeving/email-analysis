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

module.exports = React.createClass
  displayName: 'TimeLineChart'

  propTypes:
    data: V.array
    graph_width: V.number

  getDefaultProps: ->
    graph_width: 900
    data: [{
      label: ''
      values: []
    }]

  _dates_provided: ->
    data_values = _.flatten(_.pluck(@props.data, 'values'))
    return _.pluck(data_values, 'x')

  _min_date: ->
    return new Date(_.min(@_dates_provided()))

  _max_date: ->
    return new Date(_.max(@_dates_provided()))

  getInitialState: ->
    xScale: d3.time.scale().domain([new Date(2008), new Date(2015)]).range([0, @props.graph_width - 70])

  _tooltip: (label, data) ->
        label + " x: " + data.x + " y: " + data.y

  componentDidMount: ->
    @props.get_data()

  render: ->
    return $$.div null,
      LineChart
        data: @props.data
        width: @props.graph_width
        height: 400
        margin: {top: 10, bottom: 50, left: 50, right: 20}
        xScale: @state.xScale
        xAxis: {tickValues: @state.xScale.ticks(d3.time.month, 6), tickFormat: d3.time.format("%m/%y")}
        tooltipHtml: @_tooltip

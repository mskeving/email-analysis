React      = require('react')
ReactD3    = require('react-d3-components')
capitalize = require('../helpers/capitalize.coffee')
percentage = require('../helpers/percentage.coffee')
_          = require('lodash')

$$ = React.DOM
V  = React.PropTypes

BarChart = React.createFactory(ReactD3.BarChart)

module.exports = React.createClass
  displayName: 'UserStats'

  propTypes:
    user: V.object.isRequired

  getDefaultProps: ->
    message_data: [{
      label: 'somethingA',
      values: [{x: 'SomethingA', y: 10}, {x: 'SomethingB', y: 4}, {x: 'SomethingC', y: 3}]
    }]

  _format_response_percentages: ->
    ret = []
    for name, num of @props.user.response_percentages
      ret.push($$.div null, "#{capitalize(name)}: #{percentage(num)}")
    return ret

  _get_message_data: ->
    # group all messages into an object that looks like this:
    # {
    #      '2008': [message, message, message]
    #      '2009': [message]
    #      '2010': [message, message]
    # }
    # put each k, v into an array, and these are our x, y values for our BarChart.
    messages = @props.user.messages
    year_to_messages = _.groupBy(messages, (m) ->
      d = new Date(Number(m.send_time_unix) * 1000)
      d = d.toString()
      return d.substring(11, 16)
    )

    values = []
    for year, messages of year_to_messages
      values.push({x: year, y:messages.length})

    values = _.sortBy(values, (v) -> v.x)

    return [{
      label: 'something'
      values: values
    }]

  bar_chart: {
    tooltip: (x, y0, y, total) ->
      return y.toString()
  }

  render: ->
    user = @props.user

    return $$.div className: 'user-stats',
      $$.div className: 'response-percentages',
        "Response Percentages:"
        @_format_response_percentages()
      $$.div className: 'message-timeline',
        BarChart
          data: @_get_message_data()
          width: 800
          height: 400
          margin: {top: 10, bottom: 50, left: 50, right: 10}
          tooltipHtml: @bar_chart.tooltip
          colorByLabel: false


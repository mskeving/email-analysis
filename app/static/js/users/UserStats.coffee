React      = require('react')
d3         = require('d3')
capitalize = require('../helpers/capitalize.coffee')
percentage = require('../helpers/percentage.coffee')
_          = require('lodash')

$$ = React.DOM
V  = React.PropTypes

BarChart = React.createFactory(require('react-d3-components/lib/BarChart.js'))

QUARTERS = {
  'Jan': 1
  'Feb': 1
  'Mar': 1
  'Apr': 2
  'May': 2
  'Jun': 2
  'Jul': 3
  'Aug': 3
  'Sep': 3
  'Oct': 4
  'Nov': 4
  'Dec': 4
}

module.exports = React.createClass
  displayName: 'UserStats'

  propTypes:
    user: V.object.isRequired

  getDefaultProps: ->
    message_data: [{
      label: 'somethingA-key',
      values: [
        {x: 'SomethingA', y: 10}
        {x: 'SomethingB', y: 4}
        {x: 'SomethingC', y: 100}
      ]
    }]

  _get_response_percentages: ->
    ret = []
    for name, num of @props.user.response_percentages
      ret.push($$.div null, "#{capitalize(name)}: #{percentage(num)}")
    return ret

  _organize_by_year: (messages) ->
    messages = @props.user.messages
    year_to_messages = _.groupBy(messages, (m) ->
      d = new Date(Number(m.send_time_unix) * 1000)
      d = d.toString()
      return d.substring(11, 16)
    )

    return year_to_messages

  _get_messages_by_year: ->
    # group all messages into an object that looks like this:
    # {
    #      '2008': [message, message, message]
    #      '2009': [message]
    #      '2010': [message, message]
    # }
    # put each { k, v.length } into an array for our BarChart x, y values.
    year_to_messages = @_organize_by_year(@props.user.messages)
    values = []

    for year, messages of year_to_messages
      values.push({x: year, y:messages.length})

    values = _.sortBy(values, (v) -> v.x)

    return [{
      label: 'num-messages'
      values: values
    }]

  _get_messages_by_quarter: ->
    # group all messages into an object that looks like this:
    # {
    #      '08_1': [message, message, message]
    #      '08_2': [message]
    #      '08_3': [message, message]
    #      '08_4': [message, message]
    #      '09_1': [message, message]
    # }
    # put each { k, v.length } into an array for our BarChart x, y values.
    year_to_messages = @_organize_by_year(@props.user.messages)

    values = []
    for year, messages of year_to_messages
      month_to_messages = _.groupBy(messages, (m) ->
        d = new Date(Number(m.send_time_unix) * 1000)
        d = d.toString()
        return d.substring(4, 7)
      )
      quarterly = { 1: [], 2: [], 3: [], 4:[] }
      for month, messages of month_to_messages
        quarter = QUARTERS[month]
        quarterly[quarter].push(messages)

      year_abbrev = year.slice(2)
      for quarter, messages of quarterly
        messages = _.flatten(messages)
        values.push({x: "#{year_abbrev}_#{quarter}", y:messages.length})

      values = _.sortBy(values, (v) -> v.x)

    return [{
      label: 'num-messages'
      values: values
    }]

  bar_chart: {
    tooltip: (x, y0, y, total) ->
      return y.toString()

    tick_format: (tick) ->
      if tick.endsWith('_1')
        return "'#{tick.split("_")[0]}"
      return ''

    # use this scale when getting messages by quarter
    yScale: d3.scale.linear().domain([0,70]).range([340, 0])
  }

  render: ->
    user = @props.user

    return $$.div className: 'user-stats',
      $$.div className: 'response-percentages',
        "Response Percentages:"
        @_get_response_percentages()
      $$.div className: 'message-timeline',
        BarChart
          data: @_get_messages_by_quarter()
          width: 800
          height: 400
          margin: {top: 10, bottom: 50, left: 50, right: 10}
          tooltipHtml: @bar_chart.tooltip
          colorByLabel: false
          xAxis: { tickFormat: @bar_chart.tick_format }
          yAxis: { label: "Number of Messages" }
          yScale: @bar_chart.yScale

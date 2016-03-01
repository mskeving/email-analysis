React      = require('react')
d3         = require('d3')
capitalize = require('../helpers/capitalize.coffee')
percentage = require('../helpers/percentage.coffee')
group_by   = require('lodash/collection/groupby')
sort_by    = require('lodash/collection/sortby')
flatten    = require('lodash/array/flatten')

$$ = React.DOM
V  = React.PropTypes

BarChart   = React.createFactory(require('react-d3-components/lib/BarChart.js'))
Switch     = React.createFactory(require('../common/Switch.coffee'))

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
  displayName: 'BarChartMsgCount'

  propTypes:
    messages: V.array
    title: V.string
    option_one: V.string
    option_two: V.string
    yearly_y_scale: V.func
    quarterly_y_scale: V.func

  getInitialState: ->
    is_yearly: true

  bar_chart_defaults: {
    tooltiphtml: (x, y0, y, total) ->
      return y.toString()

    width: 400
    height: 200
    margin: {top: 10, bottom: 50, left: 50, right: 10}
    colorByLabel: false
    xAxis: { tickFormat: null }
    yAxis: { label: "Y axis label" }
    yScale: null
  }

  _organize_by_year: (messages) ->
    year_to_messages = group_by(messages, (m) ->
      d = new Date(Number(m.send_time_unix) * 1000)
      d = d.toString()
      return d.substring(11, 16)
    )

    return year_to_messages

  _get_messages_by_year: (messages) ->
    # group all messages into an object that looks like this:
    # {
    #      '2008': [message, message, message]
    #      '2009': [message]
    #      '2010': [message, message]
    # }
    # put each { k, v.length } into an array for our BarChart x, y values.
    year_to_messages = @_organize_by_year(messages)
    values = []

    for year, messages of year_to_messages
      values.push({x: year, y:messages.length})

    values = sort_by(values, (v) -> v.x)

    return [{
      label: 'num-messages'
      values: values
    }]

  _get_messages_by_quarter: (messages)->
    # group all messages into an object that looks like this:
    # {
    #      '08_1': [message, message, message]
    #      '08_2': [message]
    #      '08_3': [message, message]
    #      '08_4': [message, message]
    #      '09_1': [message, message]
    # }
    # put each { k, v.length } into an array for our BarChart x, y values.
    year_to_messages = @_organize_by_year(messages)

    values = []
    for year, messages of year_to_messages
      month_to_messages = group_by(messages, (m) ->
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
        messages = flatten(messages)
        values.push({x: "#{year_abbrev}_#{quarter}", y:messages.length})

      values = sort_by(values, (v) -> v.x)

    return [{
      label: 'num-messages'
      values: values
    }]


  _get_chart: ->
    messages = @props.messages

    # if it's not yearly, it's quarterly.
    if @state.is_yearly
      yScale = @props.yearly_y_scale or d3.scale.linear().domain([0,200]).range([140, 0])
      $$.div className: 'yearly',
        BarChart
          data: @_get_messages_by_year(messages)
          width: @bar_chart_defaults.width
          height: @bar_chart_defaults.height
          margin: @bar_chart_defaults.margin
          tooltipHtml: @bar_chart_defaults.tooltiphtml
          colorByLabel: @bar_chart_defaults.colorByLabel
          xAxis: { tickFormat: (tick) ->
            return "'#{tick.slice(2)}"
          }
          yScale: yScale
    else
      yScale = @props.quarterly_y_scale or d3.scale.linear().domain([0,70]).range([140, 0])
      $$.div className: 'quarterly',
        BarChart
          data: @_get_messages_by_quarter(messages)
          width: @bar_chart_defaults.width
          height: @bar_chart_defaults.height
          margin: @bar_chart_defaults.margin
          tooltipHtml: @bar_chart_defaults.tooltiphtml
          colorByLabel: @bar_chart_defaults.colorByLabel
          xAxis: { tickFormat: (tick) ->
            if tick.endsWith('_1')
              # only show '08 for the first quarter
              return "'#{tick.split("_")[0]}"
            return ''
          }
          yScale: yScale

  _toggle_is_yearly: ->
    @setState
      is_yearly: !@state.is_yearly

  render: ->
    return $$.div className: 'bar-chart',
      $$.div className: 'messages-sent',
        $$.div className: 'title',
          @props.title
        Switch
          option_one: "yearly"
          option_two: "quarterly"
          on_click: @_toggle_is_yearly
        @_get_chart()

React   = require('react')
$       = require('jquery')
ReactD3 = require('react-d3-components')
$$      = React.DOM

StringCount   = React.createFactory(require('./StringCount.coffee'))
MessageCount  = React.createFactory(require('./MessageCount.coffee'))
TimeLineChart = React.createFactory(require('../common/TimeLineChart.coffee'))
BarChart      = React.createFactory(ReactD3.BarChart)

module.exports = React.createClass
  displayName: 'StatDisplay'

  getInitialState: ->
    message_counts: []
    message_count_chart_title: []
    msgs_over_time: [{
      label: ''
      values: [{x: new Date(2008, 2, 5), y: 1}]
    }]
    msgs_over_time_bargraph: [
      {
        label: '2015',
        values: [
          {x: 'missy', y: 24}
          {x: 'jen', y: 20}
        ]
      }
    ]

  _get_msgs_over_time: ->
    $.ajax
      type: "GET"
      data: {}
      dataType: 'JSON'
      url: "/stats/message_time_graph"
      success: (data) =>
        @setState
          msgs_over_time: data

      error: (e) =>
        @setState
          msgs_over_time: []
        console.log "There was an error with the message count search"

  _get_msgs_over_time_bargraph: ->
    $.ajax
      type: "GET"
      data: {}
      dataType: 'JSON'
      url: "/stats/message_time_bargraph"
      success: (data) =>
        @setState
          msgs_over_time_bargraph: data

      error: (e) =>
        @setState
          msgs_over_time: []
        console.log "There was an error with the message count search"

  _get_str_count: (str) ->
    data = {
      string_to_match: str
    }

    $.ajax
      type: "GET"
      data: data
      dataType: 'JSON'
      url: "/stats/get_count"
      success: (data) =>
        @setState
          str_count: data.usr_to_str_counts
          str_count_chart_title: "Matches for \"#{str}\""
          str_count_subtitle: "Case Insensitive"

      error: (e) =>
        @setState
          data: []
          title: "Error with this search"

  _get_messages_count: ->
    data = {}

    $.ajax
      type: "GET"
      data: data
      dataType: 'JSON'
      url: "/stats/get_message_count"
      success: (data) =>
        @setState
          message_counts: data
          message_count_chart_title: "Total Messages Sent"

      error: (e) =>
        @setState
          data: []
          message_count_chart_title: "Total Messages Sent - Error"
        console.log "There was an error with the message count search"

  componentDidMount: ->
    @_get_msgs_over_time_bargraph()

  tooltip: (x, y0, y, total) ->
    return y.toString();

  render: ->
    $$.div null,
      BarChart
        groupedBars: true
        width: 400
        height: 400
        data: @state.msgs_over_time_bargraph
        tooltipHtml: @tooltip
        tooltipMode: 'mouse'
        margin: {top: 10, bottom: 50, left: 50, right: 10}
      TimeLineChart
        data: @state.msgs_over_time
        get_data: @_get_msgs_over_time
      StringCount
        get_data: @_get_str_count
        data: @state.str_count
        chart_title: @state.str_count_chart_title
        chart_sub_title: @state.str_count_subtitle
      MessageCount
        get_data: @_get_messages_count
        data: @state.message_counts
        chart_title: @state.message_count_chart_title

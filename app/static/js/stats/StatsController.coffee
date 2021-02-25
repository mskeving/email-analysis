require("../../stylesheets/stats.scss")

React            = require('react')
BarChartMsgCount = require('../common/BarChartMsgCount')
MyBarChart       = require('../common/MyBarChart')
Preloader        = require('../common/Preloader')
StringCount      = require('./StringCount')

module.exports = React.createClass
  displayName: 'StatsController'

  getInitialState: ->
    message_counts: [{x: '', y: 0}]
    str_counts: {}
    all_messages: [{id: null, time_stamp_unix: null}]

  _get_str_count: (str) ->
    $.ajax
      type: "GET"
      data: { string_to_match: str }
      dataType: 'JSON'
      url: "/stats/get_count"
      success: (data) =>
        @setState
          str_count: data.usr_to_str_counts
          str_count_chart_title: "Matches for \"#{str}\""

      error: (e) =>
        alert "Error fetching data for string count"
        @setState
          str_count: []

  _get_messages_count: ->
    $.ajax
      type: "GET"
      data: {}
      dataType: 'JSON'
      url: "/stats/get_message_count"
      success: (data) =>
        @setState
          message_counts: data

      error: (e) =>
        @setState
          message_counts: []
        console.log "Error fetching data for message count"

  _get_all_messages: ->
    $.ajax
      type: "GET"
      data: {}
      dataType: 'JSON'
      url: "/api/all_messages"
      success: (data) =>
        @setState
          all_messages: data

      error: (e) =>
        @setState
          message_counts: []
        console.log "Error fetching all messages"

  componentDidMount: ->
    @_get_messages_count()
    @_get_all_messages()

  _message_count_data: ->
    return [{
      label: 'count',
      values: @state.message_counts
    }]

  _get_display_or_waiting: ->
    if @state.message_counts.length
      return (
        <div>
          <StringCount
            get_data={@_get_str_count}
            values={@state.str_count}
            chart_title={@state.str_count_chart_title}
            chart_sub_title="Case Insensitive"
          />
          <MyBarChart
            title="Messages by User"
            data={@_message_count_data()}
          />
          <div className="bar-chart-email-count">
            <BarChartMsgCount
              messages={@state.all_messages}
              title="Total Messages Sent"
              option_one="yearly"
              option_two="quarterly"
              yearly_y_scale={d3.scale.linear().domain([0, 900]).range([140, 0])}
              quarterly_y_scale={d3.scale.linear().domain([0, 300]).range([140, 0])}
            />
          </div>
        </div>
      )
    else
      return (
        <Preloader />
      )

  render: -> return (
    <div className="page-container extra-container">
      {@_get_display_or_waiting()}
    </div>
  )

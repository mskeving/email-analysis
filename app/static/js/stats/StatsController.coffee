require("../../stylesheets/stats.scss")

React       = require('react')
$           = require('jquery')
StringCount = require('./StringCount.coffee')
BarChart    = require('../common/barchart/BarChart.coffee')
NavBar      = require('../common/NavBar.coffee')

module.exports = React.createClass
  displayName: 'StatsController'

  getInitialState: ->
    message_counts: []

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

  render: ->
    <div>
      <StringCount
        get_data={@_get_str_count}
        data={@state.str_count}
        chart_title={@state.str_count_chart_title}
        chart_sub_title="Case Insensitive"
      />
      <BarChart
        get_data={@_get_messages_count}
        data={@state.message_counts}
        title="Total Messages Sent"
      />

    </div>

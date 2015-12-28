React   = require('react')
$       = require('jquery')
$$      = React.DOM

StringCount  = React.createFactory(require('./StringCount.coffee'))
MessageCount = React.createFactory(require('./MessageCount.coffee'))

module.exports = React.createClass
  displayName: 'StatDisplay'

  getInitialState: ->
    message_counts: []
    message_count_chart_title: []

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

  render: ->
    $$.div null,
      StringCount
        get_data: @_get_str_count
        data: @state.str_count
        chart_title: @state.str_count_chart_title
        chart_sub_title: @state.str_count_subtitle
      MessageCount
        get_data: @_get_messages_count
        data: @state.message_counts
        chart_title: @state.message_count_chart_title

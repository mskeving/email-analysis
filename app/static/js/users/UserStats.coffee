React      = require('react')
capitalize = require('../helpers/capitalize.coffee')
percentage = require('../helpers/percentage.coffee')
seconds_to_time = require('../helpers/seconds_to_time.coffee')

$$ = React.DOM
V  = React.PropTypes

BarChartMsgCount = React.createFactory(require('../common/BarChartMsgCount.coffee'))
Table            = React.createFactory(require('./Table.coffee'))

module.exports = React.createClass
  displayName: 'UserStats'

  propTypes:
    user: V.object.isRequired

  _get_response_percentages: ->
    ret = []
    for name, num of @props.user.response_percentages
      ret.push({"#{capitalize(name)}": "#{percentage(num)}"})
    return ret

  _get_facts: ->
    all_caps = Number(@props.user.num_words_all_caps)
    return [
      { "Total emails sent": @props.user.message_count }
      { "Average word count": @props.user.avg_word_count }
      { "Total threads initiated": @props.user.initiating_msgs.length }
      { "Percentage of words in all caps": "#{percentage(all_caps/Number(@props.user.word_count) * 100)}" }
      { "Average response time": "#{seconds_to_time(@props.user.avg_response_time)}" }
    ]

  render: ->
    user = @props.user

    return $$.div className: 'user-stats',
      $$.div className: "table",
        Table
          title: ""
          items: @_get_facts()
      $$.div className: 'msg-graphs',
        BarChartMsgCount
          messages: user.messages
          option_one: "yearly"
          option_two: "quarterly"
          title: "Emails Sent"
          yearly_y_scale: d3.scale.linear().domain([0, 210]).range([140, 0])
          quarterly_y_scale: d3.scale.linear().domain([0, 70]).range([140, 0])
        BarChartMsgCount
          messages: user.initiating_msgs
          option_one: "yearly"
          option_two: "quarterly"
          title: "Initiated Threads"
          yearly_y_scale: d3.scale.linear().domain([0, 85]).range([140, 0])
          quarterly_y_scale: d3.scale.linear().domain([0, 30]).range([140, 0])
      $$.div className: 'table',
        Table
          title: "Response Percentages"
          items: @_get_response_percentages()

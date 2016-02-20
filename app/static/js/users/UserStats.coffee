React      = require('react')
capitalize = require('../helpers/capitalize.coffee')
percentage = require('../helpers/percentage.coffee')

$$ = React.DOM
V  = React.PropTypes

BarChartMsgCount = React.createFactory(require('../common/BarChartMsgCount.coffee'))

module.exports = React.createClass
  displayName: 'UserStats'

  propTypes:
    user: V.object.isRequired

  _get_response_percentages: ->
    ret = []
    for name, num of @props.user.response_percentages
      ret.push($$.div null, "#{capitalize(name)}: #{percentage(num)}")
    return ret

  render: ->
    user = @props.user

    return $$.div className: 'user-stats',
      $$.div className: 'response-percentages',
        "Response Percentages:"
        @_get_response_percentages()
      BarChartMsgCount
        messages: user.messages
        option_one: "yearly"
        option_two: "quarterly"
        title: "Emails Sent"
      BarChartMsgCount
        messages: user.initiating_msgs
        option_one: "yearly"
        option_two: "quarterly"
        title: "Initiated Threads"

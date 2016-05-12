React      = require('react')
capitalize = require('../helpers/capitalize.coffee')
percentage = require('../helpers/percentage.coffee')

$$ = React.DOM
V  = React.PropTypes

BarChartMsgCount = React.createFactory(require('../common/BarChartMsgCount.coffee'))
Table            = React.createFactory(require('./Table.coffee'))

module.exports = React.createClass
  displayName: 'UserStats'

  propTypes:
    user: V.object.isRequired

  _get_response_percentage: (category) ->
    ret = []

    if category is "you_respond_to"
      response_percentage = @props.user.you_respond_to
    else if category is "responds_to_you"
      response_percentage = @props.user.responds_to_you

    for name, num of response_percentage
      ret.push({"#{capitalize(name)}": "#{percentage(num)}"})

    return ret

  render: ->
    user = @props.user
    name = capitalize(user.name)

    return $$.div className: 'user-stats',
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
      $$.div className: "response-container",
        $$.div className: 'section-title',
          "Response Percentages"
        $$.div className: "responses",
          $$.div className: 'response-percentages',
            Table
              description: "How often others respond to #{name}"
              items: @_get_response_percentage("responds_to_you")
          $$.div className: 'response-percentages',
            Table
              description: "How often #{name} responds to"
              items: @_get_response_percentage("you_respond_to")

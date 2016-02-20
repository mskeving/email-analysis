React   = require('react')
$$      = React.DOM
V       = React.PropTypes

module.exports = React.createClass
  displayName: 'Switch'

  propTypes:
    option_one: V.string
    option_two: V.string
    on_click: V.func

  getDefaultProps: ->
    option_one: "off"
    option_two: "on"
    on_click: ->

  render: ->
    $$.div className: "switch",
      $$.label null,
        @props.option_one
        $$.input
          type: "checkbox"
          onClick: @props.on_click
        $$.span
          className: "lever"
        @props.option_two

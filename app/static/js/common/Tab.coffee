require("../../css/tab.css")
React = require('react')
cls   = require('classnames')
$$    = React.DOM
V     = React.PropTypes

module.exports = React.createClass
  displayName: 'Tab'

  propTypes:
    options: V.array
    on_click: V.func
    selected_option: V.object

  render: ->
    return $$.div
      className: 'tab-container',
        @props.options.map((option) =>
          return $$.div
            className: cls('tab', {
              'active': option is @props.selected_option
            })
            onClick: => @props.on_click(option),
            option.name
        )

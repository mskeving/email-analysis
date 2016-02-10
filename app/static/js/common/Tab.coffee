require("../../stylesheets/components/_tab.scss")

React      = require('react')
cls        = require('classnames')
capitalize = require('../helpers/capitalize.coffee')

$$ = React.DOM
V  = React.PropTypes

module.exports = React.createClass
  displayName: 'Tab'

  propTypes:
    options: V.array
    on_click: V.func
    selected_option: V.object

  render: ->
    return $$.div
      className: 'tab-container',
        @props.options.map((option, i) =>
          return $$.div
            className: cls('tab', {
              'active': option is @props.selected_option
            })
            key: i
            onClick: => @props.on_click(option),
            capitalize(option.name)
        )

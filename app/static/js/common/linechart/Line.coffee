React   = require('react')
$$      = React.DOM

module.exports = React.createClass
  displayName: 'Line'

  getDefaultProps: ->
    path: ''
    color: 'blue'
    width: 2

  render: ->
    return $$.path
      d: @props.path
      stroke: @props.color
      strokeWidth: @props.width
      fill: "none"

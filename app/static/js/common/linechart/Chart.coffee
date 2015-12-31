React   = require('react')
$$      = React.DOM

module.exports = React.createClass
  displayName: 'Chart'

  render: ->
    return $$.svg
      width: @props.width
      height: @props.height,
      @props.children

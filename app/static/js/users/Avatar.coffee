React   = require('react')
$$      = React.DOM
V       = React.PropTypes

module.exports = React.createClass
  displayName: 'UserCard'

  propTypes:
    link: V.string

  render: ->
    $$.img
      className: 'avatar-container'
      src: @props.link

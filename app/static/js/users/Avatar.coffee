React   = require('react')
$$      = React.DOM
V       = React.PropTypes

module.exports = React.createClass
  displayName: 'Avatar'

  propTypes:
    link: V.string

  render: ->
    $$.div className: 'avatar-container',
        $$.img
          src: @props.link

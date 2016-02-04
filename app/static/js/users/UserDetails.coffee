React   = require('react')
$$      = React.DOM
V       = React.PropTypes

module.exports = React.createClass
  displayName: 'UserDetails'

  propTypes:
    user: V.object

  render: ->
    return $$.div className: 'user-details',
      if @props.user
        @props.user.name
      else
        "No User Selected"

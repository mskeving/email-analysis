React   = require('react')
$$      = React.DOM
V       = React.PropTypes

UserBasics = React.createFactory(require('./UserBasics.coffee'))
UserStats  = React.createFactory(require('./UserStats.coffee'))

module.exports = React.createClass
  displayName: 'UserDetails'

  propTypes:
    user: V.object.isRequired

  render: ->
    return $$.div className: 'user-details',
      UserBasics
        avatar_link: @props.user.avatar_link
        name: @props.user.name
        email_addresses: @props.user.email_addresses
      UserStats
        user: @props.user

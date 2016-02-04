React   = require('react')
$$      = React.DOM
V       = React.PropTypes

Avatar       = React.createFactory(require('./Avatar.coffee'))
UserCardInfo = React.createFactory(require('./UserCardInfo.coffee'))

module.exports = React.createClass
  displayName: 'UserCard'

  propTypes:
    user: V.object
    select_this_user: V.function

  render: ->
    u = @props.user

    return $$.div
      className: 'user-container'
      onClick: => @props.select_this_user(u),
      Avatar
        link: u.avatar_link
      UserCardInfo
        name: u.name
        email_addresses: u.addresses

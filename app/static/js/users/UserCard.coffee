React   = require('react')
$$      = React.DOM
V       = React.PropTypes

Avatar   = React.createFactory(require('./Avatar.coffee'))
UserInfo = React.createFactory(require('./UserInfo.coffee'))

module.exports = React.createClass
  displayName: 'UserCard'

  propTypes:
    avatar_link: V.string
    name: V.string
    email_addresses: V.array

  _capitalize: (word) ->
    return "#{word[0].toUpperCase()}#{word.slice(1)}"

  render: ->
    $$.div className: 'user-container',
      Avatar
        link: @props.avatar_link
      UserInfo
        name: @props.name
        email_addresses: @props.email_addresses

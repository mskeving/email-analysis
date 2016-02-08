React   = require('react')
map     = require('lodash/collection/map')
$$      = React.DOM
V       = React.PropTypes

Avatar = React.createFactory(require('./Avatar.coffee'))

module.exports = React.createClass
  displayName: 'UserBasics'

  propTypes:
    email_addresses: V.array
    avatar_link: V.string
    name: V.string

  _capitalize: (word) ->
    return word[0].toUpperCase() + word.slice(1).toLowerCase()

  render: ->
    return $$.div className: 'user-basics',
      Avatar
        link: @props.avatar_link
      $$.div className: 'text',
        $$.div className: 'name',
          @_capitalize(@props.name)
        map(@props.email_addresses, (address, i) ->
          return $$.div
            className: 'email'
            key: i,
            address
        )

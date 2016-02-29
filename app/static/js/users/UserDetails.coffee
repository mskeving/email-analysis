React      = require('react')
map        = require('lodash/collection/map')
capitalize = require('../helpers/capitalize.coffee')
CardReveal = React.createFactory(require('../common/CardReveal.coffee'))

$$ = React.DOM
V  = React.PropTypes

Avatar = React.createFactory(require('./Avatar.coffee'))

module.exports = React.createClass
  displayName: 'UserDetails'

  propTypes:
    user: V.object.isRequired

  _get_email_addresses: ->
    return map(@props.user.addresses, (address, i) ->
      return $$.div
        className: 'email'
        key: i,
        address
    )

  render: ->
    return $$.div className: 'row user-details',
      CardReveal
        avatar_link: @props.user.avatar_link
        hidden_info: @_get_email_addresses()
        title: @props.user.name

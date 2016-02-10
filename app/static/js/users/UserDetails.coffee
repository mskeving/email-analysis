React   = require('react')
map     = require('lodash/collection/map')
$$      = React.DOM
V       = React.PropTypes

Avatar = React.createFactory(require('./Avatar.coffee'))

module.exports = React.createClass
  displayName: 'UserDetails'

  propTypes:
    user: V.object.isRequired

  _capitalize: (word) ->
    return word[0].toUpperCase() + word.slice(1).toLowerCase()

  _get_email_addresses: ->
    return map(@props.user.addresses, (address, i) ->
      return $$.div
        className: 'email'
        key: i,
        address
    )

  _get_facts: ->
    return $$.div className: 'facts',
      $$.div null,
        "Number of messages sent: #{@props.user.message_count}"
      $$.div null,
        "Average word count per message: #{@props.user.avg_word_count}"

  render: ->
    user = @props.user

    return $$.div className: 'user-details',
      $$.div className: 'user-basics',
        Avatar
          link: user.avatar_link
        $$.div className: 'text',
          $$.div className: 'name',
            @_capitalize(user.name)
          $$.div className: 'addresses',
            @_get_email_addresses()
          @_get_facts()

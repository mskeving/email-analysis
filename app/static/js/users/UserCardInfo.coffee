React   = require('react')
$$      = React.DOM
V       = React.PropTypes

module.exports = React.createClass
  displayName: 'UserCardInfo'

  propTypes:
    name: V.string
    email_addresses: V.array

  _capitalize: (word) ->
    return "#{word[0].toUpperCase()}#{word.slice(1)}"

  render: ->
    $$.div className: 'user-info',
      $$.div
        className: 'user-name'
        onClick: @_go_to_user_page,
        @_capitalize(@props.name)
      $$.div
        className: 'category-title',
        'Email addresses:'
        @props.email_addresses.map((email, i) ->
          return $$.div
            className: 'email-address'
            key: i,
              email
        )

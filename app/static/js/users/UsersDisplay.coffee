React   = require('react')
$$      = React.DOM
V       = React.PropTypes

UserCard    = React.createFactory(require('./UserCard.coffee'))
UserDetails = React.createFactory(require('./UserDetails.coffee'))

module.exports = React.createClass
  displayName: 'UsersDisplay'

  propTypes:
    users: V.array
    select_user: V.function
    selected_user: V.object

  _get_user_cards: ->
    user_cards = @props.users.map((u) =>
        return UserCard
          key: u.id
          user: u
          select_this_user: @props.select_user
      )
    return user_cards

  render: ->
    $$.div null,
      $$.div className: 'user-cards',
        @_get_user_cards()
      UserDetails
        user: @props.selected_user

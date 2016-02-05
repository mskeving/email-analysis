React   = require('react')
_       = require('lodash')
$$      = React.DOM
V       = React.PropTypes

Tab         = React.createFactory(require('../common/Tab.coffee'))
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
    return $$.div
      className: 'user-container',
        Tab
          options: @props.users
          on_click: @props.select_user
          selected_option: @props.selected_user
        UserDetails
          user: @props.selected_user

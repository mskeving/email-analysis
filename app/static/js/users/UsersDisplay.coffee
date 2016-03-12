React = require('react')
$$    = React.DOM
V     = React.PropTypes

Tab         = React.createFactory(require('../common/Tab.coffee'))
UserDetails = React.createFactory(require('./UserDetails.coffee'))
UserStats   = React.createFactory(require('./UserStats.coffee'))

module.exports = React.createClass
  displayName: 'UsersDisplay'

  propTypes:
    users: V.array
    select_user: V.func
    selected_user: V.object

  render: ->
    return $$.div null,
      Tab
        options: @props.users
        on_click: @props.select_user
        selected_option: @props.selected_user
      UserDetails
        user: @props.selected_user
      UserStats
        user: @props.selected_user

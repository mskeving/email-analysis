React   = require('react')
$       = require('jquery')
_       = require('lodash')
$$      = React.DOM

UsersDisplay = React.createFactory(require('./UsersDisplay.coffee'))

module.exports = React.createClass
  displayName: 'UsersController'

  getInitialState: ->
    users: []
    selected_user: null

  componentDidMount: ->
    @_fetch_users()

  _fetch_users: ->
    $.ajax
      url: "/api/users"
      type: "GET"
      data: {}
      dataType: "JSON"
      success: (data) =>
        @setState
          users: data
      error: (e) ->
        console.log "error getting data: #{e}"

  select_user: (u) ->
    idx = _.indexOf(@state.users, u)
    @setState
      selected_user: @state.users[idx]

  render: ->
    UsersDisplay
      users: @state.users
      select_user: @select_user
      selected_user: @state.selected_user

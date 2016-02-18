React   = require('react')
$       = require('jquery')
_       = require('lodash')
$$      = React.DOM

UsersDisplay = React.createFactory(require('./UsersDisplay.coffee'))
NavBar       = React.createFactory(require('../common/NavBar.coffee'))

module.exports = React.createClass
  displayName: 'UsersController'

  getInitialState: ->
    users: []
    selected_user: null

  componentWillMount: ->
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
          selected_user: data[0]
      error: (e) ->
        console.log "error getting data: #{e}"

  select_user: (u) ->
    idx = _.indexOf(@state.users, u)
    @setState
      selected_user: @state.users[idx]

  _get_display_or_waiting: ->
    if @state.selected_user?
      return UsersDisplay
        users: @state.users
        select_user: @select_user
        selected_user: @state.selected_user
    else
      return $$.div className: "user-container",
        "Fetching data..."

  render: ->
    return $$.div null,
      NavBar null
      @_get_display_or_waiting()


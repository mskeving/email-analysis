React   = require('react')
$       = require('jquery')
$$      = React.DOM

UserCard = React.createFactory(require('./UserCard.coffee'))

module.exports = React.createClass
  displayName: 'UsersController'

  getInitialState: ->
    return users: []

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

  render: ->
    $$.div null,
      @state.users.map((u) ->
        return UserCard
          key: u.id
          name: u.name
          email_addresses: u.addresses
          avatar_link: u.avatar_link
      )

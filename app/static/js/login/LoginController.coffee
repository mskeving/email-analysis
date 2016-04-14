React  = require('react')
$      = require('jquery')

LoginDisplay = require('./LoginDisplay')

module.exports = React.createClass
  displayName: 'LoginController'

  getInitialState: ->
    username: ""
    password: ""
    message: ""

  update_username: (username) ->
    @setState
      username: username

  update_password: (password) ->
    @setState
      password: password

  submit_login: (username, password) ->
    data = {
      username: @state.username,
      password: @state.password
    }

    $.ajax
      type: "POST"
      data: data
      dataType: "JSON"
      url: "/submit_login"
      success: (data) =>
        if data.message is "success"
          location.href = "/"
        else
          @setState
            message: data.message

      error: (e) =>
        console.log "ERROR!"

  render: ->
    return (
        <LoginDisplay
          message={@state.message}
          submit_login={@submit_login}
          update_password={@update_password}
          update_username={@update_username}
        />
    )

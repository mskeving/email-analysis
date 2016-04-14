React     = require('react')
LoginForm = require('./LoginForm')
V         = React.PropTypes

module.exports = React.createClass
  displayName: 'LoginDisplay'

  propTypes:
    submit_login: V.func
    update_username: V.func
    update_password: V.func

  render: ->
    return(
      <div className="login-form-container">
        <h4 className="title">
          Login to Skarkov
        </h4>
        <LoginForm
          submit_login={@props.submit_login}
          update_password={@props.update_password}
          update_username={@props.update_username}
          message={@props.message}
        />
      </div>
    )

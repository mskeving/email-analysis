React  = require('react')
Button = require('../common/Button')
V      = React.PropTypes

module.exports = React.createClass
  displayName: 'LoginForm'

  propTypes:
    submit_login: V.func
    update_username: V.func
    update_password: V.func

  getDefaultProps: ->
    message: ""

  handle_submit: ->
    @props.submit_login()

  handle_password_change: (event) ->
    @props.update_password(event.target.value)

  handle_username_change: (event) ->
    @props.update_username(event.target.value)

  render: ->
    return(
    	<div className="row">
  	    <form className="col s12">
  	      <div className="row">
  	        <div className="input-field col s12">
  	          <input onChange={@handle_username_change} id="username" type="text" className="validate"/>
  	          <label htmlFor="username">Username</label>
  	        </div>
  	      </div>
  	      <div className="row">
  	        <div className="input-field col s12">
  	          <input onChange={@handle_password_change} id="password" type="password" className="validate"/>
  	          <label htmlFor="password">Password</label>
  	        </div>
  	      </div>
  	    </form>
        <div className="message">
          {@props.message}
        </div>
        <Button text="login" on_click={@handle_submit} />
  	  </div>
    )

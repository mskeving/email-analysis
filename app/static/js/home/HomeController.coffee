React       = require('react')
HomeDisplay = require('./HomeDisplay')
Preloader   = require('../common/Preloader')

module.exports = React.createClass
  displayName: 'HomeController'

  getInitialState: ->
    facts: []

  componentWillMount: ->
    $.ajax
      data: {}
      url: '/facts'
      type: 'POST'
      dataType: 'JSON'
      success: (data) =>
        @setState
          facts: data.facts

      error: (jqXHR, textStatus, errorThrown) ->
        console.log "Error #{jqXHR}, #{textStatus}, #{errorThrown}"

  _get_display_or_waiting: ->
    if @state.facts.length
      return <HomeDisplay facts=@state.facts />
    else
      return (
        <Preloader />
      )

  render: ->
    return (
      <div className="home-container">
        {@_get_display_or_waiting()}
      </div>
    )

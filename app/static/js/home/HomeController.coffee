React       = require('react')
$           = require('jquery')
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
        facts = data.facts
        @setState
          facts: facts

      error: (jqXHR, textStatus, errorThrown) ->
        alert "Error #{jqXHR}, #{textStatus}, #{errorThrown}"

  _get_display_or_waiting: ->
    if @state.facts.length
      return <HomeDisplay facts=@state.facts />
    else
      return (
        <Preloader />
      )

  render: ->
    return (
      <div>
        <div className="home-container">
          {@_get_display_or_waiting()}
        </div>
      </div>
    )

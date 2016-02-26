React   = require('react')
$       = require('jquery')
$$      = React.DOM

HomeDisplay = React.createFactory(require('./HomeDisplay.coffee'))
NavBar      = React.createFactory(require('../common/NavBar.coffee'))
Preloader   = React.createFactory(require('../common/Preloader.coffee'))

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
      return HomeDisplay
        facts: @state.facts
    else
      return $$.div className: "preloader-container",
        Preloader null

  render: ->
    return $$.div null,
      NavBar null
      $$.div className: "home-container",
        @_get_display_or_waiting()

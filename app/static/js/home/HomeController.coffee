React   = require('react')
$       = require('jquery')
$$      = React.DOM

HomeDisplay = React.createFactory(require('./HomeDisplay.coffee'))

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

  render: ->
    return HomeDisplay
      facts: @state.facts

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
        facts = [
          "There have been #{data.num_messages} unqiue messages between us"
          "The first message sent had the subject \"#{data.first_msg.subject}\""
        ]
        @setState
          facts: facts

      error: (jqXHR, textStatus, errorThrown) ->
        alert "Error #{jqXHR}, #{textStatus}, #{errorThrown}"

  render: ->
    return HomeDisplay
      facts: @state.facts

React   = require('react')
cls     = require('classnames')
$       = require('jquery')
$$      = React.DOM

module.exports = React.createClass
  displayName: 'Chain'

  getDefaultProps: ->
    userName: "Default Username"
    chain: "Default Markov Chain"

  getMarkov: (e) ->
    $.ajax
      data: {'user_name': @props.userName}
      url: '/get_markov'
      type: 'POST'
      success: (new_chain) ->
        @setState chain: new_chain
      error: (e) ->
        console.log(e)

  render: ->
    $$.div className: "user",
      $$.div className: "chain-info",
        $$.div className: "name",
          @props.userName
        $$.div className: "chain",
          @props.chain
      $$.div className: "options",
        $$.div
          className: cls(['btn', 'new'])
          onClick: @getMarkov,
          "new"
        $$.div
          className: cls(['btn', 'tweet'])
          onClick: @getMarkov,
          "tweet"


React   = require('react')
map     = require('lodash/collection/map')
$       = require('jquery')
$$      = React.DOM

Chain = React.createFactory(require('./Chain.coffee'))

module.exports = React.createClass
  displayName: 'UserMarkovs'

  getInitialState: ->
    markovs: []

  loadMarkovs: ->
    $.ajax
      url: '/get_markovs'
      type: 'POST'
      dataType: 'JSON'
      success: (markovs) =>
        @setState
          markovs: markovs
      error: (e) ->
        alert "error retrieving Markov chains: #{e}"

  componentDidMount: ->
    @loadMarkovs()

  renderChain: (markov_dict) ->
    return Chain
      user_name: markov_dict.user_name
      chain: markov_dict.markov_dict.chain
      id: markov_dict.markov_dict.id
      key: markov_dict.markov_dict.user_id

  render: ->
    chainNodes = map(@state.markovs, @renderChain)

    return $$.div className: "container",
      $$.a
        className: "reference"
        href:"http://www.piliapp.com/twitter-symbols/",
          "User Symbols"
      chainNodes

React   = require('react')
$       = require('jquery')
$$      = React.DOM

Chain = React.createFactory(require('./Chain.coffee'))

module.exports = React.createClass
  displayName: 'UserMarkov'

  getInitialState: ->
    d = {'missy': 'value'}
    return d

  loadMarkovs: ->
    self = @
    $.ajax
      url: '/get_markovs'
      type: 'POST'
      success: (markov_dict) ->
        for user_name, markov of markov_dict
          new_state = {}
          new_state[user_name] = markov
          self.setState new_state
      error: (e) ->
        console.log(e)

  componentDidMount: ->
    console.log "mounted"
    @loadMarkovs()

  markovNodes: ->
    if @state
      chainNodes = for user_name, chain of @state
        chain_dict = {}
        chain_dict[user_name] = chain
        Chain(chain_dict)
      return chainNodes

  render: ->
    $$.div className: "container",
      $$.a
        className: "reference"
        href:"http://www.piliapp.com/twitter-symbols/",
          "User Symbols"
      @markovNodes()

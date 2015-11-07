React   = require('react')
_       = require('lodash')
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

  _get_new_markov: (user_name) ->
    data =
      user_name: user_name

    $.ajax
      data: data
      url: '/get_one_markov'
      type: 'POST'
      dataType: 'JSON'
      success: (markov_info) =>
        new_markov_list = _.remove(@state.markovs, (m) -> m.user_name == username)
        new_markov_list.push(markov_info)
        @setState
          markovs: new_markov_list
      error: (e) ->
        alert "Error retrieving Markov chain: #{e}"

  renderChain: (markov_info) ->
    return Chain
      markov_info: markov_info
      get_new_markov: @_get_new_markov
      key: markov_info.markov_dict.user_id

  render: ->
    chainNodes = _.map(@state.markovs, @renderChain)

    return $$.div className: "container",
      $$.a
        className: "reference"
        href:"http://www.piliapp.com/twitter-symbols/",
          "User Symbols"
      chainNodes

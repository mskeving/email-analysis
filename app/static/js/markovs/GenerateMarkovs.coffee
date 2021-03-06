require("../../stylesheets/skarkov.scss")

React     = require('react')
_         = require('lodash')
Chain     = require('./Chain')
Preloader = require('../common/Preloader')

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
      success: (markov_dict) =>
        # find the index of the markov to change based on user name
        # and update that. Can't remove and append new one
        # because it will change the order.
        markovs = @state.markovs
        idx = _.indexOf(markovs, _.find(markovs, {user_name: user_name}))
        markovs[idx].markov_dict = markov_dict
        @setState
          markovs: markovs
      error: (e) ->
        alert "Error retrieving Markov chain: #{e}"

  renderChain: (markov_info) ->
    return (
      <Chain
        markov_info={markov_info}
        get_new_markov={@_get_new_markov}
        key={markov_info.markov_dict.user_id}
      />
    )

  _get_display_or_waiting: ->
    if @state.markovs.length
      return (
        <div>
          <div className="top-options">
            <a
              className="reference"
              href="http://www.piliapp.com/twitter-symbols/"
              target="_blank"
            >
              User Symbols
            </a>
            <div
              className="refresh"
              onClick=@loadMarkovs
            >
              Refresh All
            </div>
          </div>
          {_.map(@state.markovs, @renderChain)}
        </div>
      )
    else
      return (
        <Preloader />
      )

  render: ->
    return (
      <div className="skarkov-container">
        {@_get_display_or_waiting()}
      </div>
    )

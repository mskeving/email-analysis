React   = require('react')
cls     = require('classnames')
$       = require('jquery')
$$      = React.DOM

module.exports = React.createClass
  displayName: 'Chain'

  getInitialState: ->
    # TODO: probably shouldn't keep state in here.
    # just get the chain passed in as a prop from Markovs
    chain: @props.chain
    id: @props.id

  getMarkov: ->
    data =
      user_name: @props.user_name

    $.ajax
      data: data
      url: '/get_one_markov'
      type: 'POST'
      dataType: 'JSON'
      success: (markov_dict) =>
        @setState
          chain: markov_dict.chain
          id: markov_dict.id
      error: (e) ->
        alert "Error retrieving Markov chain: #{e}"

  tweetMarkov: ->
    data =
      markov_id: @state.id
    $.ajax
      data: data
      url: '/tweet'
      type: 'POST'
      success: =>
        tweet_url = "http://twitter.com/home?status=\"#{@state.chain}\" - "

        win = window.open(tweet_url, '_blank')
        if win
          win.focus()
        else
          # Browser settings have prevented pop ups
          alert "Please allow pop-ups."
      error: (e) ->
        alert "Error marking this chain as tweeted: #{e}"

  render: ->
    $$.div className: "user",
      $$.div className: "chain-info",
        $$.div className: "name",
          @props.user_name
        $$.div className: "chain",
          @state.chain
      $$.div className: "options",
        $$.div
          className: cls(['btn', 'new'])
          onClick: @getMarkov,
          "new"
        $$.div
          className: cls(['btn', 'tweet'])
          onClick: @tweetMarkov,
          "tweet"

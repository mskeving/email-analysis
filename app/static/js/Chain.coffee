React   = require('react')
cls     = require('classnames')
$       = require('jquery')
$$      = React.DOM

module.exports = React.createClass
  displayName: 'Chain'

  tweetMarkov: ->
    data =
      markov_id: @props.markov_info.markov_dict.id
    $.ajax
      data: data
      url: '/tweet'
      type: 'POST'
      success: =>
        tweet_url = "http://twitter.com/home?status=\"#{@props.markov_info.markov_dict.chain}\" - "

        win = window.open(tweet_url, '_blank')
        if win
          win.focus()
        else
          # Browser settings have prevented pop ups
          alert "Please allow pop-ups."
      error: (e) ->
        alert "Error marking this chain as tweeted: #{e}"

  _get_markov: ->
    @props.get_new_markov(@props.markov_info.user_name)

  render: ->
    $$.div className: "user",
      $$.img if @props.markov_info.markov_dict.is_legit
        className: "legit"
        src: "/static/images/legit-stamp.png"
      $$.div className: "chain-info",
        $$.div className: "name",
          @props.markov_info.user_name
        $$.div className: "chain",
          @props.markov_info.markov_dict.chain
      $$.div className: "options",
        $$.div
          className: cls(['btn', 'new'])
          onClick: @_get_markov
          "new"
        $$.div
          className: cls(['btn', 'tweet'])
          onClick: @tweetMarkov,
          "tweet"

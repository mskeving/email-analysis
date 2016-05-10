React     = require('react')

module.exports = React.createClass
  displayName: 'TweetTimeline'

  componentDidMount: ->
    # Twitter needs this js embedded in order for the timeline
    # to appear. Instead of including this in base.jade, I'm
    # adding it for this component, and removing it once we navigate
    # to a different page. It has to be added after mounting.
    twitter_js = document.createElement("script")
    twitter_js.id = "twitter-wjs"
    twitter_js.src = "http://platform.twitter.com/widgets.js"
    document.body.appendChild(twitter_js)

  componentWillUnmount: ->
    twitter_script = document.getElementById("twitter-wjs")
    parent_script = twitter_script.parentNode
    parent_script.removeChild(twitter_script)

  render: ->
    return (
      <div className="page-container">
        <div className="timeline-container" style={textAlign: 'center'}>
          <a
            style={display: 'None'}
            className="twitter-timeline"
            data-dnt="true"
            href="https://twitter.com/skev_says"
            data-widget-id="720487689502474240">
            Markov Chains by @skev_says
          </a>
        </div>
      </div>
    )




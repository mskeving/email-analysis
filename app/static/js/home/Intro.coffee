React  = require('react')
Slider = require('react-slick')
V      = React.PropTypes
$$     = React.DOM

module.exports = React.createClass
  displayName: 'Intro'

  propTypes:
    facts: V.array

  getDefaultProps: ->
    facts: []

  _get_facts: ->
    console.log "getting facts"
    return (
      @props.facts.map((fact, i) ->
        return <div key={i}>{fact}</div>
      )
    )

  render: ->
    settings = {
      autoplay: true,
      autoplaySpeed: 6000,
      dots: true,
      infinite: true,
      speed: 500,
      slidesToShow: 1,
      slidesToScroll: 1
    }
    return (
      <div className="intro-container">
        <div className="content">
          <div>
            <Slider {...settings}>
              {@_get_facts()}
            </Slider>
          </div>
        </div>
        <div className="trust">
          <div className="quote red lighten-4">"Skarkov is the best email analysis on the web. period." -- <strong>Forbes</strong></div>
        </div>
      </div>
    )

React = require('react')
V     = React.PropTypes

module.exports = React.createClass
  displayName: 'PrefilledInput'

  propTypes:
    text: V.string
    on_click: V.func

  getDefaultProps: ->
    prefill: "Search"

  render: ->
    return (
      <a
        className="cyan darken-2 waves-effect waves-light btn"
        onClick={@props.on_click}
      >
        {@props.text}
      </a>
    )

require("../../stylesheets/components/_graph_title.scss")
React   = require('react')
$$      = React.DOM
V       = React.PropTypes

module.exports = React.createClass
  displayName: 'GraphTitle'

  propTypes:
    text: V.string

  getDefaultProps: ->
    text: "Graph Title"

  render: ->
    return $$.div
      className: "graph-title",
        @props.text

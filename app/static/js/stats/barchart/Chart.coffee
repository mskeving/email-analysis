React   = require('react')
$$      = React.DOM

module.exports = React.createClass
  displayName: 'Chart'

  render: ->
    $$.div 
      className: "bar-chart-container",
      $$.div
        className: "bar-chart-title",
        @props.title
      $$.svg
        className: "bar-chart"
        width: @props.width
        height: @props.height,
        @props.children

React   = require('react')
$$      = React.DOM

module.exports = React.createClass
  displayName: 'Chart'

  getDefaultProps: ->
    title: "Chart Title"
    subtitle: ""
    width: 500
    height: 500

  render: ->
    $$.div 
      className: "bar-chart-container",
      $$.div
        className: "bar-chart-title",
        @props.title
      $$.div
        className: "bar-chart-subtitle",
        @props.subtitle
      $$.svg
        className: "bar-chart"
        width: @props.width
        height: @props.height,
        @props.children

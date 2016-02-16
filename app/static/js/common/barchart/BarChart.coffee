React   = require('react')
V       = React.PropTypes
$$      = React.DOM

Bar = React.createFactory(require('./Bar.coffee'))

module.exports = React.createClass
  displayName: 'Chart'

  propTypes:
    get_data: V.func
    data: V.array

  getDefaultProps: ->
    title: "Chart Title"
    subtitle: ""
    width: 500
    height: 500

  componentDidMount: ->
    if @props.get_data
      @props.get_data()

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
        Bar
          data: @props.data
          width: @props.width
          height: @props.height

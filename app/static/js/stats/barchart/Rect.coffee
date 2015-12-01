React   = require('react')
_       = require('lodash')
d3      = require('d3')
$$      = React.DOM

SetIntervalMixin = {
  componentWillMount: ->
    @intervals = []
  setInterval: ->
    @intervals.push(setInterval.apply(null, arguments))
  componentWillUnmount: ->
    @intervals.map(clearInterval)
}

module.exports = React.createClass
  displayName: 'Rect'

  mixins: [SetIntervalMixin]

  getDefaultProps: ->
    width: 0
    height: 0
    x: 0
    y: 0

  getInitialState: ->
    milliseconds: 0
    height: 0

  shouldComponentUpdate: (nextProps) ->
    return @props.height != @state.height

  componentWillReceiveProps: (nextProps) ->
    @setState
      milliseconds: 0
      height: @props.height

  componentDidMount: ->
    @setInterval(@tick, 10)

  tick: (start) ->
    @setState
      milliseconds: @state.milliseconds + 10

  render: ->
    easyeasy = d3.ease('back-out')
    bar_height = @state.height + (@props.height - @state.height) * easyeasy(Math.min(1, @state.milliseconds/1000))
    y_value_height = @props.y * easyeasy(Math.min(1, @state.milliseconds/1000))
    y = @props.height - bar_height + @props.y
    return $$.g null,
      $$.rect
        className: "bar"
        height: _.max([bar_height, 0])
        y: y
        width: @props.width
        x: @props.x
      $$.text
        x: @props.x + 10
        y: @props.height + @props.y + 15,
        @props.x_value
      $$.text
        x: @props.x + 20
        y: _.max([y_value_height - 10, 0])
        @props.y_value
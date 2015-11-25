React   = require('react')
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
    easyeasy = d3.ease('back-out');
    height = @state.height + (@props.height - @state.height) * easyeasy(Math.min(1, @state.milliseconds/1000))
    # height = @state.height + (@props.height - @state.height) * easyeasy(2)
    y = @props.height - height + @props.y
    # debugger
    return $$.rect
      className: "bar"
      height: height
      y: y
      width: @props.width
      x: @props.x
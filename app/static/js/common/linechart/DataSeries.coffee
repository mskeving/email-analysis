React   = require('react')
$$      = React.DOM

Line = React.createFactory(require('./Line.coffee'))

module.exports = React.createClass
  displayName: 'DataSeries'

  getDefaultProps: ->
    title: ''
    data: []
    interpolate: 'linear'
    color: 'black'

  render: ->
    path = d3.svg.line()
      .x( (d) => return @props.xScale(d.x))
      .y( (d) => return @props.yScale(d.y))
      .interpolate(@props.interpolate)

    return Line
      path: path(@props.data)
      color: @props.color

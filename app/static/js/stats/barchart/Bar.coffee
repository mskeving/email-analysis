React   = require('react')
d3      = require('d3')
$$      = React.DOM

Rect = React.createFactory(require('./Rect.coffee'))

module.exports = React.createClass
  displayName: 'Bar'

  getDefaultProps: ->
    data: []

  shouldComponentUpdate: (nextProps) ->
    @props.data != nextProps.data

  render: ->
    props = @props
    data = props.data.map((d) ->
      return d.y
    )

    yScale = d3.scale.linear()
      .domain([0, d3.max(data)])
      .range([0, props.height])

    xScale = d3.scale.ordinal()
      .domain(d3.range(props.data.length))
      .rangeRoundBands([0, props.width], .05)

    bars = @props.data.map((point, i) ->
      height = yScale(point.y)
      y = props.height - height
      width = xScale.rangeBand()
      x = xScale(i)

      return Rect
        height: height
        width: width
        x: x
        y: y
        key: i
        label: point.x
    )

    return $$.g null,
      bars

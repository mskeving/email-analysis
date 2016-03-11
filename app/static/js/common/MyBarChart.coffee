React   = require('react')
V       = React.PropTypes
$$      = React.DOM

BarChart = require('react-d3-components/lib/BarChart')

module.exports = React.createClass
  displayName: 'MyBarChart'

  propTypes:
    get_data: V.func
    data: V.array

  getDefaultProps: ->
    title: "Chart Title"
    data: [{
      label: 'example',
      values: [{x: '', y: 0}]
    }]

  render: ->
    <div className="bar-chart-container">
      <div className="bar-chart-title">
        {@props.title}
      </div>
      <BarChart
        data={@props.data}
        width={400}
        height={400}
        margin={{top: 10, bottom: 50, left: 50, right: 10}}
        tooltipHtml={(x, y0, y, total) ->
          return y.toString()
        }
      />
    </div>

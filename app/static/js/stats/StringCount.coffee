React   = require('react')
_       = require('lodash')
$$      = React.DOM
V       = React.PropTypes

BarChart       = require('react-d3-components/lib/BarChart')
PrefilledInput = require('../common/PrefilledInput')
Button         = require('../common/Button')

module.exports = React.createClass
  displayName: 'StringCount'

  propTypes:
    get_data: V.func.isRequired
    chart_title: V.string
    values: V.array

  getDefaultProps: ->
    values: [{x: '', y: 0}]
    chart_title: ""
    get_data: ->

  _run_search: ->
    @props.get_data(@state.search_term)

  _update_search_term: (value) ->
    @setState
      search_term: value

  data: ->
    return [{
      label: 'count',
      values: @props.values
    }]

  componentDidMount: ->
    @props.get_data('!')

  render: -> return (
    <div className='str-count-container'>
      <div className="row">
        <div className="col s6 prefill-input">
          <PrefilledInput
            prefill="!"
            field_title="Search Term"
            on_change={@_update_search_term}
          />
        </div>
        <div className="col s3">
          <Button text="search" on_click={@_run_search} />
        </div>
      </div>
      <div className="row">
        <div className="col bar-chart">
          <div className="bar-chart-title">{@props.chart_title}</div>
          <BarChart
            data={@data()}
            width={400}
            height={400}
            margin={{top: 10, bottom: 50, left: 50, right: 10}}
            tooltipHtml={(x, y0, y, total) ->
              return y.toString()
            }
          />
        </div>
      </div>
    </div>
  )

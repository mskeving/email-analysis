React   = require('react')
_       = require('lodash')
$$      = React.DOM
V       = React.PropTypes

BarChart       = React.createFactory(require('react-d3-components/lib/BarChart.js'))
PrefilledInput = React.createFactory(require('../common/PrefilledInput'))
Button         = React.createFactory(require('../common/Button'))

module.exports = React.createClass
  displayName: 'StringCount'

  propTypes:
    get_data: V.func.isRequired
    chart_title: V.string

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

  render: ->
    $$.div className: 'str-count-container',
      $$.div className: "row",
        $$.div className: "col s6 prefill-input",
          PrefilledInput
            prefill: "!"
            field_title: "Search Term"
            on_change: @_update_search_term
        $$.div className: "col s3",
          Button
            text: "test"
            on_click: @_run_search
      $$.div className: "bar-chart",
        $$.h5 null, @props.chart_title
        BarChart
          data: @data()
          width: 400
          height: 400
          margin: {top: 10, bottom: 50, left: 50, right: 10}
          tooltipHtml: (x, y0, y, total) ->
            return y.toString()

React   = require('react')
_       = require('lodash')
$$      = React.DOM
V       = React.PropTypes

SearchOption = React.createFactory(require('./SearchOption.coffee'))
BarChart     = React.createFactory(require('react-d3-components/lib/BarChart.js'))

SAVED_SEARCHES = [
  "!", "haha", "drunk", "family", "friends", "wine", "dog"
]

module.exports = React.createClass
  displayName: 'StringCount'

  propTypes:
    get_data: V.func.isRequired
    chart_title: V.string

  getDefaultProps: ->
    values: [{x: '', y: 0}]
    chart_title: ""
    get_data: ->

  _new_search: ->
    str = document.getElementById('search-str').value
    @props.get_data(str)

  _saved_search: (str) ->
    # if you click on a saved search, clear input box
    document.getElementById('search-str').value = ""
    @props.get_data(str)

  _render_search_option: (str, i) ->
    return SearchOption
      onClick: @_saved_search
      searchStr: str
      key: i

  data: ->
    return [{
      label: 'count',
      values: @props.values
    }]

  componentDidMount: ->
    @props.get_data('!')

  render: ->
    $$.div
      className: 'str-count-container',
      $$.div
        className: "search-options-container",
        _.map(SAVED_SEARCHES, @_render_search_option)
        $$.div
          className: 'search-custom',
          $$.div
            className: "search-custom-label",
            "Custom: "
          $$.input
            id: "search-str"
            type: "text"
          $$.div
            id: "btn-search-str"
            className: "btn-search"
            onClick: @_new_search,
            "search"
      $$.div className: "bar-chart",
        $$.h5 null, @props.chart_title
        BarChart
          data: @data()
          width: 400
          height: 400
          margin: {top: 10, bottom: 50, left: 50, right: 10}
          tooltipHtml: (x, y0, y, total) ->
            return y.toString()

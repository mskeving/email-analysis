React   = require('react')
_       = require('lodash')
$       = require('jquery')
$$      = React.DOM
V       = React.PropTypes

Bar            = React.createFactory(require('../common/barchart/Bar.coffee'))
BarChart       = React.createFactory(require('../common/barchart/BarChart.coffee'))
SearchOption   = React.createFactory(require('./SearchOption.coffee'))

SAVED_SEARCHES = [
  "!", "haha", "drunk", "family", "friends", "wine", "dog"
]

module.exports = React.createClass
  displayName: 'StringCount'

  propTypes:
    get_data: V.func.isRequired

  getDefaultProps: ->
    width: 500
    height: 500
    data: []
    chart_title: ""

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
      BarChart
        width: @props.width
        height: @props.height
        get_data: => @props.get_data('!')
        title: @props.chart_title
        subtitle: @props.chart_sub_title
        data: @props.data

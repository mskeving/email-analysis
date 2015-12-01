React   = require('react')
_       = require('lodash')
$       = require('jquery')
$$      = React.DOM

Bar            = React.createFactory(require('./barchart/Bar.coffee'))
Chart          = React.createFactory(require('./barchart/Chart.coffee'))
SearchOption   = React.createFactory(require('./SearchOption.coffee'))

SAVED_SEARCHES = [
  "!", "haha", "wine", "drunk", "family", "friends", "wine", "dog"
]

module.exports = React.createClass
  displayName: 'StringCount'

  getDefaultProps: ->
    width: 500
    height: 500

  getInitialState: ->
    data: []
    chart_title: ""

  componentDidMount: ->
    @query('!')

  query: (str) ->
    data = {
      string_to_match: str
    }

    $.ajax
      type: "GET"
      data: data
      dataType: 'JSON'
      url: "/stats/get_count"
      success: (data) =>
        @setState
          data: data.values
          chart_title: "Matches for \"#{str}\""
      error: (e) =>
        @setState
          data: []
          title: "Error with this search"

  _new_search: ->
    str = document.getElementById('search-str').value
    @query(str)

  _saved_search: (str) ->
    @query(str)

  _render_search_option: (str) ->
    return SearchOption
      onClick: @_saved_search
      searchStr: str

  render: ->
    $$.div null,
      $$.div
        className: "search-option-container",
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
      Chart
        width: @props.width
        height: @props.height
        title: @state.chart_title,
        Bar
          data: @state.data
          width: @props.width
          height: @props.height

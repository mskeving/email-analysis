React   = require('react')
$       = require('jquery')
$$      = React.DOM

Chart = React.createFactory(require('./barchart/Chart.coffee'))
Bar   = React.createFactory(require('./barchart/Bar.coffee'))

module.exports = React.createClass
  displayName: 'StringCount'

  getDefaultProps: ->
    width: 500
    height: 500

  getInitialState: ->
    data: []

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
        console.log data
        @setState
          data: data.values
      error: (e) ->
        console.log "error: #{e}"

  _new_search: ->
    str = document.getElementById('search-str').value
    @query(str)

  render: ->
    $$.div null,
      $$.div null,
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
        height: @props.height,
        Bar
          data: @state.data
          width: @props.width
          height: @props.height

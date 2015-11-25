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
        @setState
          data: data.values
      error: (e) ->
        console.log "error: #{e}"

  showAll: ->
    @setState
      data: [
        {x: "missy", y: 1}
        {x: "crysty", y: 2}
        {x: "jen", y: 3}
        {x: "mary", y: 4}
      ]

  render: ->
    $$.div null,
      $$.div className: "selection",
        $$.ul null,
          $$.li
            onClick: @new_search,
            "missy"
          $$.li
            onClick: @new_search,
            "jen"
      Chart
        width: @props.width
        height: @props.height,
        Bar
          data: @state.data
          width: @props.width
          height: @props.height

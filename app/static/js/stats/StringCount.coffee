React   = require('react')
$$      = React.DOM

Chart = React.createFactory(require('./barchart/Chart.coffee'))
Bar   = React.createFactory(require('./barchart/Bar.coffee'))

module.exports = React.createClass
  displayName: 'StringCount'

  getDefaultProps: ->
    width: 500
    height: 500

  getInitialState: ->
    data: [
      {x: "missy", y: 1}
      {x: "crysty", y: 2}
      {x: "jen", y: 3}
      {x: "mary", y: 4}
    ]

  showAll: ->
    @setState
      data: [
        {x: "missy", y: 1}
        {x: "crysty", y: 2}
        {x: "jen", y: 3}
        {x: "mary", y: 4}
      ]

  filter: ->
    @setState
      data: [
        {x: "missy", y: 1}
        {x: "crysty", y: 2}
      ]

  render: ->
    $$.div null,
      $$.div className: "selection",
        $$.ul null,
          $$.li
            onClick: @showAll,
            "All"
          $$.li
            onClick: @filter,
            "Filter"
      Chart
        width: @props.width
        height: @props.height,
        Bar
          data: @state.data
          width: @props.width
          height: @props.height


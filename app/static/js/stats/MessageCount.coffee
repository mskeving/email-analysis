React   = require('react')
$$      = React.DOM

Bar            = React.createFactory(require('./barchart/Bar.coffee'))
Chart          = React.createFactory(require('./barchart/Chart.coffee'))

module.exports = React.createClass
  displayName: 'MessageCount'

  getDefaultProps: ->
    data: []
    chart_title: ""
    width: 500
    height: 500

  componentDidMount: ->
    @props.get_data()

  render: ->
    Chart
      width: @props.width
      height: @props.height
      title: @props.chart_title
      Bar
        data: @props.data
        width: @props.width
        height: @props.height

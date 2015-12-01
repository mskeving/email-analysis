React   = require('react')
$$      = React.DOM

module.exports = React.createClass
  displayName: 'SearchOption'

  _on_click: ->
    @props.onClick(@props.searchStr)

  render: ->
    $$.div 
      className: "search-option"
      onClick: @_on_click,
      @props.searchStr

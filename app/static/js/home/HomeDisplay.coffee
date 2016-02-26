React   = require('react')
$$      = React.DOM
V       = React.PropTypes

Facts  = React.createFactory(require('./Facts.coffee'))

module.exports = React.createClass
  displayName: 'HomeDisplay'

  propTypes:
    facts: V.array

  render: ->
    return $$.div null,
        Facts
          facts: @props.facts

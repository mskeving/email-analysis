React   = require('react')
$$      = React.DOM
V       = React.PropTypes

NavBar = React.createFactory(require('../common/NavBar.coffee'))
Facts  = React.createFactory(require('./Facts.coffee'))

module.exports = React.createClass
  displayName: 'HomeDisplay'

  propTypes:
    facts: V.array

  render: ->
    return $$.div null,
      NavBar null
      $$.div className: "home-container",
        Facts
          facts: @props.facts

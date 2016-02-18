React   = require('react')
$$      = React.DOM

NavBar = React.createFactory(require('../common/NavBar.coffee'))

module.exports = React.createClass
  displayName: 'HomeDisplay'

  render: ->
    return $$.div null,
      NavBar null
      $$.div className: "home-container",
        "Welcome"

require("../stylesheets/base.scss")
React  = require('react')
NavBar = require('./common/NavBar')

module.exports = React.createClass
  displayName: 'App'

  render: ->
    return (
      <div>
        <NavBar />
        {@props.children}
      </div>
    )

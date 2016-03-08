require("../stylesheets/base.scss")
React  = require('react')
NavBar = require('./common/NavBar')
Footer = require('./common/Footer')

module.exports = React.createClass
  displayName: 'App'

  getInitialState: ->
    last_import: ""

  componentWillMount: ->
    $.ajax
      url: "/api/base"
      type: "POST"
      data: {}
      dataType: "JSON"
      success: (data) =>
        @setState
          last_import: data.last_import
      error: (e) ->
        console.log "error getting data: #{e}"

  render: ->
    return (
      <div className="app-container">
        <NavBar />
        <main>
            {@props.children}
        </main>
        <Footer last_import={@state.last_import}/>
      </div>
    )

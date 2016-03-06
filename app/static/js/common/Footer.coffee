React          = require('react')
unix_to_date   = require('../helpers/unix_to_date')
V              = React.PropTypes

module.exports = React.createClass
  displayName: 'Footer'

  propTypes:
    last_import: V.string

  getDefaultProps: ->
    last_import: "unknown"

  render: ->
    return (
      <footer className="page-footer">
        <div className="footer-copyright">
          <div className="container">
          © 2016 Skev, Inc. Skarkov is a trademark of Skev, Inc.
          <div className="grey-text text-lighten-4 right import-date">
            Last updated: {unix_to_date(@props.last_import)}
          </div>
          </div>
        </div>
      </footer>
    )

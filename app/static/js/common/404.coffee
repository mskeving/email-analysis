React  = require('react')

module.exports = React.createClass
  displayName: '404'

  render: ->
    return (
      <div className="notfound-container">
        <h4 className="text">{"You've lost your way."}</h4>
        <img src="/static/images/kili_bowl.jpg" />
      </div>
    )

React = require('react')
V     = React.PropTypes

module.exports = React.createClass
  displayName: 'CardReveal'

  propTypes:
    avatar_link: V.string
    hidden_info: V.node
    title: V.string

  getDefaultProps: ->
    title: "Card Title"
    hidden_info: "This is what is shown here."

  render: ->
    return (
        <div className="card">
          <div className="avatar card-image waves-effect waves-block waves-light">
            <img className="activator" src={@props.avatar_link} />
          </div>
          <div className="card-content">
            <span className="card-title activator grey-text text-darken-4">
              {@props.title}
              <i className="material-icons right">more_vert</i>
            </span>
          </div>
          <div className="card-reveal">
            <span className="card-title grey-text text-darken-4">
              {@props.title}
              <i className="material-icons right">close</i>
            </span>
            <div>
              {@props.hidden_info}
            </div>
          </div>
        </div>
    )

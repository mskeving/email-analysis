React = require('react')
V     = React.PropTypes

module.exports = React.createClass
  displayName: 'Tab'

  propTypes:
    options: V.array
    on_click: V.func
    selected_option: V.object

  componentDidMount: ->
    $('ul.tabs').tabs()

  _tab_items: ->
    return @props.options.map((option, i) =>
      return (
        <li className="tab col" key={i} onClick={=>@props.on_click(option)}>
          <a href="">{option.name}</a>
        </li>
      )
    )

  render: ->
    return (
      <div className="row">
        <div className="col">
          <ul className="tabs">
            {@_tab_items()}
          </ul>
        </div>
      </div>
    )

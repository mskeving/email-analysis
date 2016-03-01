React = require('react')
V     = React.PropTypes

module.exports = React.createClass
  displayName: 'PrefilledInput'

  propTypes:
    prefill: V.string
    field_title: V.string
    on_change: V.func

  getDefaultProps: ->
    prefill: "Alvin"
    field_title: "First Name"
    on_change: ->

  getInitialState: ->
    # the id's of each input component needs to be unique.
    _id: Date.now()

  _handle_change: ->
    value = document.getElementById(@state._id).value
    @props.on_change(value)

  render: ->
    return (
      <div className="input-field">
        <input
          className="validate"
          defaultValue={@props.prefill}
          id={@state._id}
          type="text"
          onChange={=>@_handle_change()}
        />
        <label className="active" data-for={@state._id}>{@props.field_title}</label>
      </div>
    )

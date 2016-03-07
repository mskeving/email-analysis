require("../../stylesheets/home.scss")

React   = require('react')
Intro   = require('./Intro')
$$      = React.DOM
V       = React.PropTypes


module.exports = React.createClass
  displayName: 'HomeDisplay'

  propTypes:
    facts: V.array

  render: ->
    return (
      <div>
        <Intro facts ={@props.facts} />
      </div>
    )

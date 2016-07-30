require("../../stylesheets/home.scss")

React = require('react')
Table = require('../users/Table')
V     = React.PropTypes


module.exports = React.createClass
  displayName: 'HomeDisplay'

  propTypes:
    facts: V.array

  getDefaultProps: ->
    facts: []

  _get_facts: ->
    return (
      @props.facts.map((fact, i) ->
        return <div className="fact" key={i}>{fact}</div>
      )
    )

  _get_facts_table: ->
    ret = []

    for fact in @props.facts
      descr = fact.split(':')[0]
      val = fact.split(':')[1]
      ret.push({"#{descr}": val})

    return ret

  render: ->
    return (
      <div className="content">
        <div className="header">
          <div className="title">Skarkov</div>
          <div className="sub-title">A family's email history</div>
        </div>
        <div className="facts">
          <Table items={@_get_facts_table()} />
        </div>
      </div>
    )

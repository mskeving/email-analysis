React = require('react')
V     = React.PropTypes
$$    = React.DOM

module.exports = React.createClass
  displayName: 'Facts'

  propTypes:
    facts: V.array

  render: ->
    return $$.div className: "facts-container",
      $$.div className: "title",
        "Did you know that..."
      $$.div className: "facts",
        @props.facts.map((fact, i) ->
          return $$.div
            className: 'fact'
            key: i,
            fact
        )
      $$.div className: "footer",
        "Now you know!"

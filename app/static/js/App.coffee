React       = require('react')
ReactRouter = require('react-router')
Link        = ReactRouter.Link
$$          = React.DOM

Link = React.createFactory(Link)

module.exports = React.createClass
  displayName: 'App'

  render: ->
    return $$.div null,
      $$.ul role: "nav",
        $$.li null,
          Link
            to: "/users",
            "Users"
        $$.li null,
          Link
            to: "/markovs",
            "Markovs"

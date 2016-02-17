require("../../stylesheets/components/_navbar.scss")
React   = require('react')
$$      = React.DOM

module.exports = React.createClass
  displayName: 'NavBar'

  render: ->
    return $$.div
      className: 'navbar-container',
        $$.div className: 'logo',
          $$.a href: "/",
            'Skarkov'
        $$.div className: 'options-container',
          $$.div className: 'option',
            $$.a
              href: "/users",
              'Users'
          $$.div className: 'option',
            $$.a
              href: "/markov",
              'Markovs'
          $$.div className: 'option',
            $$.a
              href: "/markov",
              'Interactive'


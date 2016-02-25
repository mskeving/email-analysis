React   = require('react')
$$      = React.DOM

module.exports = React.createClass
  displayName: 'NavBar'

  nav_items: [
      { name: 'Users', href: '/users' }
      { name: 'Markovs', href: '/markov' }
      { name: 'Extra', href: '/stats' }
    ]

  _get_nav_items: ->
    return @nav_items.map((item, i) ->
      return $$.li key: i,
        $$.a
          href: item.href,
          item.name
    )

  componentDidMount: ->
     $(".button-collapse").sideNav()

  render: ->
    return $$.nav null,
      $$.div className: 'nav-wrapper',
        $$.a
          className: 'brand-logo'
          href: '/',
          "Skarkov"
        $$.a
          className: 'button-collapse'
          href: '#'
          'data-activates': 'mobile-demo',
            $$.i
              className: 'material-icons',
                "menu"
        $$.ul className: 'right hide-on-med-and-down',
          @_get_nav_items()
        $$.ul
          className: 'side-nav'
          id: 'mobile-demo',
            @_get_nav_items()

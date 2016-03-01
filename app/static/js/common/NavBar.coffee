React   = require('react')
{Link}  = require('react-router')

module.exports = React.createClass
  displayName: 'NavBar'

  nav_routes: [
      { name: 'Users', href: '/users' }
      { name: 'Markovs', href: '/markovs' }
      { name: 'Extra', href: '/extra' }
    ]

  _get_nav_items: ->
    return @nav_routes.map((item, i) ->
      return (
        <li key={i}>
          <Link to={item.href}>
            {item.name}
          </Link>
        </li>
      )
    )

  componentDidMount: ->
     $(".button-collapse").sideNav()

  render: ->
    return (
      <nav>
        <div className="nav-wrapper">
          <Link className="brand-logo" to="/">
            Skarkov
          </Link>
          <a className="button-collapse" href="#" data-activates="mobile-demo">
            <i className="material-icons">menu</i>
          </a>
          <ul className="right hide-on-med-and-down">
            {@_get_nav_items()}
          </ul>
          <ul className="side-nav" id="mobile-demo">
            {@_get_nav_items()}
          </ul>
        </div>
      </nav>
    )

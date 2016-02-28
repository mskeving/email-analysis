React       = require("react")
ReactDom    = require("react-dom")
{Router, Route, IndexRoute, browserHistory} = require("react-router")

App             = require('./App')
UsersController = require('./users/UsersController')
SkarkovDisplay  = require('./markovs/SkarkovDisplay')
HomeController  = require('./home/HomeController')
StatsController = require('./stats/StatsController')

router = (
  <Router history={browserHistory}>
    <Route path="/" component={App}>
      <IndexRoute component={HomeController} />
      <Route path="/users" component={UsersController} />
      <Route path="/markovs" component={SkarkovDisplay} />
      <Route path="/extra" component={StatsController} />
    </Route>
  </Router>
)

window.onload = ->
  ReactDom.render(router, window.document.getElementById('content'))

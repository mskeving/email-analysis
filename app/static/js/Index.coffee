React       = require("react")
ReactDom    = require("react-dom")
{Router, Route, IndexRoute, browserHistory} = require("react-router")

App             = require('./App')
HomeController  = require('./home/HomeController')
NotFound        = require('./common/404')
SkarkovDisplay  = require('./markovs/SkarkovDisplay')
StatsController = require('./stats/StatsController')
UsersController = require('./users/UsersController')

router = (
  <Router history={browserHistory}>
    <Route path="/" component={App}>
      <IndexRoute component={HomeController} />
      <Route path="/users" component={UsersController} />
      <Route path="/markovs" component={SkarkovDisplay} />
      <Route path="/extra" component={StatsController} />
      <Route path="/*" component={NotFound} />
    </Route>
  </Router>
)

window.onload = ->
  ReactDom.render(router, window.document.getElementById('content'))

React       = require("react")
ReactDom    = require("react-dom")
{Router, Route, IndexRoute, browserHistory} = require("react-router")

App             = require('./App')
FAQController   = require('./faq/FAQController')
HomeController  = require('./home/HomeController')
NotFound        = require('./common/404')
GenerateMarkovs  = require('./markovs/GenerateMarkovs')
StatsController = require('./stats/StatsController')
TweetTimeline   = require('./markovs/TweetTimeline')
UsersController = require('./users/UsersController')

router = (
  <Router history={browserHistory}>
    <Route path="/" component={App}>
      <IndexRoute component={HomeController} />
      <Route path="/users" component={UsersController} />
      <Route path="/markovs" component={TweetTimeline} />
      <Route path="/extra" component={StatsController} />
      <Route path="/faq" component={FAQController} />
      <Route path="/admin/markovs" component={GenerateMarkovs} />
      <Route path="/*" component={NotFound} />
    </Route>
  </Router>
)

window.onload = ->
  ReactDom.render(router, window.document.getElementById('content'))

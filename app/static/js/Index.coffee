React       = require("react")
ReactDom    = require("react-dom")
ReactRouter = require("react-router")
hashHistory = ReactRouter.hashHistory
$$          = React.DOM

Router = React.createFactory(ReactRouter.Router)
Route  = React.createFactory(ReactRouter.Route)
IndexRoute  = React.createFactory(ReactRouter.IndexRoute)

App             = React.createFactory(require('./App.coffee'))
SkarkovDisplay  = React.createFactory(require('./markovs/SkarkovDisplay.coffee'))
UsersController = React.createFactory(require('./users/UsersController.coffee'))
HomeController  = React.createFactory(require('./home/HomeController.coffee'))

router = (
  Router history: hashHistory,
    Route
      path:"/"
      component: App
    Route
      path: "/users"
      component: UsersController
    Route
      path: "/markovs"
      component: SkarkovDisplay
)

window.onload = ->
  ReactDom.render(router, window.document.getElementById('content'))

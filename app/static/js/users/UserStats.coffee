React      = require('react')
capitalize = require('../helpers/capitalize.coffee')
percentage = require('../helpers/percentage.coffee')

$$ = React.DOM
V  = React.PropTypes

module.exports = React.createClass
  displayName: 'UserStats'

  propTypes:
    user: V.object.isRequired

  _format_response_percentages: ->
    ret = []
    for name, num of @props.user.response_percentages
      ret.push($$.div null, "#{capitalize(name)}: #{percentage(num)}")
    return ret

  render: ->
    user = @props.user

    return $$.div className: 'user-stats',
      $$.div className: 'response-percentages',
        "Response Percentages:"
        @_format_response_percentages()

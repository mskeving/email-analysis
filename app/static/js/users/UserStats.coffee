React   = require('react')
$$      = React.DOM
V       = React.PropTypes

Avatar = React.createFactory(require('./Avatar.coffee'))

module.exports = React.createClass
  displayName: 'UserStats'

  propTypes:
    user: V.object

  render: ->
    user = @props.user

    return $$.div className: 'stats',
      $$.div null,
        "Number of messages sent: #{user.message_count}"
      $$.div null,
        "Average word count per message: #{user.avg_word_count}"

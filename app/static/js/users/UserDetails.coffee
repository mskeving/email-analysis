React           = require('react')
map             = require('lodash/collection/map')
capitalize      = require('../helpers/capitalize.coffee')
percentage      = require('../helpers/percentage.coffee')
seconds_to_time = require('../helpers/seconds_to_time.coffee')
CardReveal      = React.createFactory(require('../common/CardReveal.coffee'))
Table           = React.createFactory(require('./Table.coffee'))

$$ = React.DOM
V  = React.PropTypes

Avatar = React.createFactory(require('./Avatar.coffee'))

module.exports = React.createClass
  displayName: 'UserDetails'

  propTypes:
    user: V.object.isRequired

  _get_facts: ->
    all_caps = Number(@props.user.num_words_all_caps)
    return [
      { "Total emails sent": @props.user.message_count }
      { "Average word count": @props.user.avg_word_count }
      { "Total threads initiated": @props.user.initiating_msgs.length }
      { "Thread participation": "#{percentage(@props.user.thread_participation)}" }
      { "Average response time": "#{seconds_to_time(@props.user.avg_response_time)}" }
    ]

  _format_addresses: (addresses) ->
    return map(addresses, (address, i) ->
      return $$.div
        className: 'email'
        key: i,
        address
    )

  render: ->
    return $$.div className: 'row user-details',
      $$.div className: "col s3",
        CardReveal
          avatar_link: @props.user.avatar_link
          hidden_info: @_format_addresses(@props.user.addresses)
          title: capitalize(@props.user.name)
      $$.div className: "col s6",
        $$.div className: "table",
          Table
            title: ""
            items: @_get_facts()

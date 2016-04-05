React   = require('react')
$$      = React.DOM
V       = React.PropTypes
map        = require('lodash/collection/map')

module.exports = React.createClass
  displayName: 'Table'

  propTypes:
    title: V.string
    items: V.array

  getDefaultProps: ->
    title: "Table Title"
    items: []

  styles: {
    leftValue: {
      textAlign: 'right'
    }
    rightValue: {
      textAlign: 'left'
    }
  }

  _get_items: ->
    return map(@props.items, (item, i) =>
      for name, value of item
        return $$.tr
          key: i,
            $$.td style:@styles.leftValue, "#{name}:"
            $$.td style:@styles.rightValue, value
      )

  render: ->
    return $$.div null,
      $$.h5 null,
        @props.title
      $$.table null,
        $$.thead null
        $$.tbody null,
          @_get_items()



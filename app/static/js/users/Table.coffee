require("../../stylesheets/components/_table.scss")
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
    description: ""
    title: ""
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
    # Note: For now, this table is only good for two columns.
    return map(@props.items, (item, i) ->
      for name, value of item
        return $$.div
          key: i
          className: "table-row",
            $$.div className: "left-column",
              "#{name}:"
            $$.div className: "right-column",
              value
      )

  render: ->
    return $$.div className: "table-container",
      $$.h5 null,
        @props.title
      $$.div className: "description",
        @props.description
      $$.div className: "content-container",
        @_get_items()



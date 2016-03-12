React   = require('react')
$$      = React.DOM

module.exports = React.createClass
  displayName: 'Preloader'

  render: -> $$.div className: "preloader-container",
  	$$.div className: "preloader-wrapper big active",
	    $$.div className: "spinner-layer spinner-blue-only",
	      $$.div className: "circle-clipper left",
	        $$.div className: "circle"
	      $$.div className: "gap-patch",
	        $$.div className: "circle"
	      $$.div className: "circle-clipper right",
	        $$.div className: "circle"

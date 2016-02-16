"use strict";

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var React = require("react");
var d3 = require("d3");

var Chart = require("react-d3-components/lib/Chart");
var Axis = require("react-d3-components/lib/Axis");
var Bar = require("react-d3-components/lib/Bar");
var Tooltip = require("react-d3-components/lib/Tooltip");

var DefaultPropsMixin = require("react-d3-components/lib/DefaultPropsMixin");
var HeightWidthMixin = require("react-d3-components/lib/HeightWidthMixin");
var ArrayifyMixin = require("react-d3-components/lib/ArrayifyMixin");
var StackAccessorMixin = require("react-d3-components/lib/StackAccessorMixin");
var StackDataMixin = require("react-d3-components/lib/StackDataMixin");
var DefaultScalesMixin = require("react-d3-components/lib/DefaultScalesMixin");
var TooltipMixin = require("react-d3-components/lib/TooltipMixin");

var DataSet = React.createClass({
    displayName: "DataSet",

    propTypes: {
        data: React.PropTypes.array.isRequired,
        xScale: React.PropTypes.func.isRequired,
        yScale: React.PropTypes.func.isRequired,
        colorScale: React.PropTypes.func.isRequired,
        values: React.PropTypes.func.isRequired,
        label: React.PropTypes.func.isRequired,
        x: React.PropTypes.func.isRequired,
        y: React.PropTypes.func.isRequired,
        y0: React.PropTypes.func.isRequired
    },

    render: function render() {
        var _props = this.props;
        var data = _props.data;
        var xScale = _props.xScale;
        var yScale = _props.yScale;
        var colorScale = _props.colorScale;
        var values = _props.values;
        var label = _props.label;
        var x = _props.x;
        var y = _props.y;
        var y0 = _props.y0;
        var onMouseEnter = _props.onMouseEnter;
        var onMouseLeave = _props.onMouseLeave;
        var groupedBars = _props.groupedBars;

        var bars = undefined;
        if (groupedBars) {
            bars = data.map(function (stack, serieIndex) {
                return values(stack).map(function (e, index) {
                    return React.createElement(Bar, {
                        key: "" + label(stack) + "." + index,
                        width: xScale.rangeBand() / data.length,
                        height: yScale(yScale.domain()[0]) - yScale(y(e)),
                        x: xScale(x(e)) + xScale.rangeBand() * serieIndex / data.length,
                        y: yScale(y(e)),
                        fill: colorScale(label(stack)),
                        data: e,
                        onMouseEnter: onMouseEnter,
                        onMouseLeave: onMouseLeave
                    });
                });
            });
        } else {
            bars = data.map(function (stack) {
                return values(stack).map(function (e, index) {
                    return React.createElement(Bar, {
                        key: "" + label(stack) + "." + index,
                        width: xScale.rangeBand(),
                        height: yScale(yScale.domain()[0]) - yScale(y(e)),
                        x: xScale(x(e)),
                        y: yScale(y0(e) + y(e)),
                        fill: colorScale(label(stack)),
                        data: e,
                        onMouseEnter: onMouseEnter,
                        onMouseLeave: onMouseLeave
                    });
                });
            });
        }

        return React.createElement(
            "g",
            null,
            bars
        );
    }
});

var BarChart = React.createClass({
    displayName: "BarChart",

    mixins: [DefaultPropsMixin, HeightWidthMixin, ArrayifyMixin, StackAccessorMixin, StackDataMixin, DefaultScalesMixin, TooltipMixin],

    getDefaultProps: function getDefaultProps() {
        return {};
    },

    _tooltipHtml: function _tooltipHtml(d, position) {
        var xScale = this._xScale;
        var yScale = this._yScale;

        var html = this.props.tooltipHtml(this.props.x(d), this.props.y0(d), this.props.y(d));

        var midPoint = xScale.rangeBand() / 2;
        var xPos = midPoint + xScale(this.props.x(d));

        var topStack = this._data[this._data.length - 1].values;
        var topElement = null;

        // TODO: this might not scale if dataset is huge.
        // consider pre-computing yPos for each X
        for (var i = 0; i < topStack.length; i++) {
            if (this.props.x(topStack[i]) === this.props.x(d)) {
                topElement = topStack[i];
                break;
            }
        }
        var yPos = yScale(this.props.y0(topElement) + this.props.y(topElement));

        return [html, xPos, yPos];
    },

    render: function render() {
        var _props = this.props;
        var height = _props.height;
        var width = _props.width;
        var margin = _props.margin;
        var colorScale = _props.colorScale;
        var values = _props.values;
        var label = _props.label;
        var y = _props.y;
        var y0 = _props.y0;
        var x = _props.x;
        var xAxis = _props.xAxis;
        var yAxis = _props.yAxis;
        var groupedBars = _props.groupedBars;
        var data = this._data;
        var innerWidth = this._innerWidth;
        var innerHeight = this._innerHeight;
        var xScale = this._xScale;
        var yScale = this._yScale;
        var tickFormat = _props.tickFormat;

        return React.createElement(
            "div",
            null,
            React.createElement(
                Chart,
                { height: height, width: width, margin: margin },
                React.createElement(DataSet, {
                    data: data,
                    xScale: xScale,
                    yScale: yScale,
                    colorScale: colorScale,
                    values: values,
                    label: label,
                    y: y,
                    y0: y0,
                    x: x,
                    onMouseEnter: this.onMouseEnter,
                    onMouseLeave: this.onMouseLeave,
                    groupedBars: groupedBars
                }),
                React.createElement(Axis, _extends({
                    tickFormat: tickFormat,
                    className: "x axis",
                    orientation: "bottom",
                    scale: xScale,
                    height: innerHeight,
                    width: innerWidth
                }, xAxis)),
                React.createElement(Axis, _extends({
                    className: "y axis",
                    orientation: "left",
                    scale: yScale,
                    height: innerHeight,
                    width: innerWidth
                }, yAxis)),
                this.props.children
            ),
            React.createElement(Tooltip, this.state.tooltip)
        );
    }
});

module.exports = BarChart;

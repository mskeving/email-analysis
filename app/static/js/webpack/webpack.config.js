var webpack = require('webpack');

module.exports = {
    entry: {
        app: "../index.coffee",
        login: "../login/login.coffee"
    },
    devtool: 'source-map',
    output: {
        path: __dirname,
        publicPath: "http://localhost:8080/assets/",
        filename: "build/[name].bundle.js"
    },
    resolve: {
      extensions: ['', '.js', '.coffee']
    },
    module: {
        loaders: [
        {
            test: /\.js?$/,
            loaders: [],
            exclude: /node_modules/,
        },
        {
            test: /\.coffee$/,
            loaders: ['react-hot', 'coffee', 'cjsx']
        },
        {
            test: /\.css$/,
            loaders: ['style', 'css'],
        },
        {
            test: /\.scss$/,
            loaders: ['style', 'css', 'sass'],
        },
        {
            test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
            loader: "url-loader?limit=10000&mimetype=application/font-woff"
        },
        {
            test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
            loader: "file-loader"
        }

        ]
    },
};

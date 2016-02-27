module.exports = {
    entry: {
        home: "../home/home.coffee",
        skarkov: "../markovs/skarkov.coffee",
        stats: "../stats/stats.coffee",
        users: "../users/users.coffee",
        app: "../index.coffee"
    },
    output: {
        path: __dirname,
        filename: "../build/[name].bundle.js"
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
            loaders: ['coffee-loader']
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
    }
};

module.exports = {
    entry: {
        skarkov: "../markovs/skarkov.coffee",
        stats: "../stats/stats.coffee",
        users: "../users/users.coffee",
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
        }
        ]
    }
};

module.exports = {
    entry: {
        skarkov: "../markovs/Skarkov.coffee",
        stats: "../stats/Stats.coffee",
        users: "../users/Users.coffee",
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

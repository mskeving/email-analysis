module.exports = {
  entry: [ "./app.coffee" ],
  output: {
    path: __dirname,
    filename: "bundle.js"
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

const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");

const codenameAegisConfig = {
  entry: "./main.js",
  mode: process.env.NODE_ENV,
  devtool: "none",
  module: {
    rules: [
      {
        test: /\.(ttf|eot|woff|woff2|otf)$/,
        use: {
          loader: "file-loader",
          options: {
            name: "fonts/[name].[ext]"
          }
        }
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: "elm-webpack-loader",
          options: {
            cwd: path.resolve(__dirname)
          }
        }
      }
    ]
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: "index.html"
    })
  ],
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "bundle.js"
  }
};

module.exports = codenameAegisConfig;

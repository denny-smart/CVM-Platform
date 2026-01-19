const path = require('path');

const CopyPlugin = require("copy-webpack-plugin");

module.exports = {
    entry: './src/functions/app.js',
    output: {
        path: path.resolve(__dirname, 'netlify/functions'),
        filename: 'app.js',
        libraryTarget: 'commonjs',
    },
    target: 'node',
    plugins: [
        new CopyPlugin({
            patterns: [
                { from: "public", to: "public" },
            ],
        }),
    ],
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['@babel/preset-env'],
                    },
                },
            },
        ],
    },
    resolve: {
        extensions: ['.js', '.json'],
    },
};

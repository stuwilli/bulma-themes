const express = require('express');
const serveStatic = require('serve-static');
const path = require('path');

const app = express();

// Here we are configuring dist to be the folder that is used to serve up index.html
app.use('/', serveStatic(path.join(__dirname, '/dist')));

const port = process.env.PORT || 8080;
app.listen(port);

console.log(`App is listening on port: ${port}`);
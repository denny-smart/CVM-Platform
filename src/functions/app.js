// Main application entry point for Netlify Functions
const express = require('express');
const serverless = require('serverless-http');
const path = require('path');
const ejs = require('ejs');
require('dotenv').config();

const authRoutes = require('../../routes/auth'); // Adjusted path

const app = express();

// Register view engine
app.engine('ejs', ejs.renderFile);
app.set('view engine', 'ejs');
// In Netlify functions, __dirname depends on build. 
// We usually point to where the files end up or use specific copying.
// For now, let's try pointing to typical Lambda path or local relative.
app.set('views', path.join(__dirname, 'public'));

// Set up middleware
// Determine public path based on environment
const publicPath = path.join(__dirname, 'public');
app.use(express.static(publicPath));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Define routes
app.use('/auth', authRoutes);

// Home route
app.get('/', (req, res) => {
    res.render('index', { title: 'Home' });
});

// Other routes
app.get('/organizations', (req, res) => {
    res.render('org', { title: 'ForOrganizations' });
});

app.get('/volunteers', (req, res) => {
    res.render('vol', { title: 'ForVolunteers' });
});

app.get('/register', (req, res) => {
    res.render('register', { title: 'CreateAccount' });
});

app.get('/login', (req, res) => {
    res.render('login', { title: 'Login' });
});

app.get('/contact', (req, res) => {
    res.render('contact', { title: 'Contacts' });
});

// Handle other errors (e.g., server errors)
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Something went wrong!');
});

// Handle 404 errors
app.use((req, res) => {
    res.status(404).render('404', { title: '404' });
});

// Export handler
module.exports.handler = serverless(app);

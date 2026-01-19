const { Pool } = require('pg');
require('dotenv').config();

// Use NETLIFY_DATABASE_URL if available, otherwise fallback to component parts or local defaults
const connectionString = process.env.NETLIFY_DATABASE_URL || process.env.DATABASE_URL;

const pool = new Pool({
    connectionString,
    ssl: {
        rejectUnauthorized: false // Required for some cloud providers like Neon/Heroku
    }
});

// Test the connection
pool.connect((err, client, release) => {
    if (err) {
        console.error('Database connection failed:', err.stack);
    } else {
        console.log('Database connected successfully.');
        release();
    }
});

module.exports = pool;
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

// Unexpected error handling for the idle pool
pool.on('error', (err, client) => {
    console.error('Unexpected error on idle client', err);
    process.exit(-1);
});

module.exports = pool;
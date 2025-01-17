import pg from 'pg';
import { readFileSync } from 'fs';
import { createHash } from 'crypto';
import dotenv from 'dotenv';

const headers = {
    'Access-Control-Allow-Origin': 'http://localhost:5173', 
    'Access-Control-Allow-Methods': 'POST, GET, OPTIONS', 
    'Access-Control-Allow-Headers': 'Content-Type', 
};


export async function POST({ request }) {

    if (request.method === "OPTIONS") {
        return new Response(null, { status: 204, headers });
    }

    dotenv.config();
    
    const body = await request.json();
    const hashedPassword = createHash('sha256').update(body.password).digest('hex');

    const client = new pg.Client({
        user: process.env.DBUSER,
        host: process.env.DB_HOST,
        database: 'safe_call',
        password: process.env.DBPASSWORD,
        port: 5432,
    });
    await client.connect()
    .then(() => { console.log('connected to database'); })
    .catch((e) => { console.error('error connecting to db: ', e); });

    const sql = 'INSERT INTO users (username, password) VALUES ($1, $2);'
    let user;
    try {
        user = await client.query(sql, [body.username, hashedPassword]);
    } catch (error) {
        console.error(error);
        return new Response(JSON.stringify({ error: 'Failed to create user'}), { status: 400 });
    }
    client.end();
    return new Response(null, { status: 200 });
}


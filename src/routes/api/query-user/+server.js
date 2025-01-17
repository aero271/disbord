import { readFileSync } from 'fs';
import pg from 'pg';
import dotenv from 'dotenv';
import { createHash } from 'crypto';

const headers = {
    'Access-Control-Allow-Origin': 'http://localhost:5173', 
    'Access-Control-Allow-Methods': 'POST, GET, OPTIONS', 
    'Access-Control-Allow-Headers': 'Content-Type', 
};

export async function GET() {
    return new Response();
};

export async function POST(event) {
    if (event.request.method === "OPTIONS") {
        return new Response(null, { status: 204, headers });
    }

    dotenv.config();
    
    const body = await event.request.json();

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

    let result;
    const sql = "SELECT * FROM users WHERE username = $1;"
    try {
        result = await client.query(sql, [body.username]);
    } catch (error) {
        console.error(error);
    }
    if (typeof result.rows[0] === "undefined") {
        return new Response(JSON.stringify({ error: "Failed to find user (probably doesn't exist)" }), { status: 400 });
    }

    const hashedPassword = createHash('sha256').update(body.password).digest('hex');
    if (result.rows[0].password !== hashedPassword) {
        return new Response(JSON.stringify({ error: "Incorrect Password" }), { status: 403, headers: { "Content-Type": "application/json" }});
    }

    client.end();

    return new Response(JSON.stringify(result), { status: 200, headers: { "Content-Type": "application/json" }});
}
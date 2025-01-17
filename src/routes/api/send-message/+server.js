import pg from 'pg';
import { readFileSync } from 'fs';
import dotenv from 'dotenv';


export async function POST({ request }) {
    dotenv.config();
    const data = await request.json();
    const messageContent = data.message;

    //object containing userid and chatid constructed in load of +page.server.js
    const chatData = data.chatData;

    //postgres boiler plate
    const client = new pg.Client({
        user: process.env.DBUSER,
        host: process.env.DB_HOST,
        database: 'safe_call',
        password: process.env.DBPASSWORD,
        port: 5432,
    });
    await client.connect()
    .catch((e) => { console.error('error connecting to db: ', e); });

    //creates the message
    const createMessageSql = 'INSERT INTO messages (content, user_id, chat_id) VALUES ($1, $2, $3);'
    await client.query(createMessageSql, [messageContent, chatData.userId, chatData.chatId]);

    client.end();
    return new Response(null, { status: 200 });
}
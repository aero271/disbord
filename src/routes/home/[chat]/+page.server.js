import { redirect } from '@sveltejs/kit';
import { readFileSync } from 'fs';
import dotenv from 'dotenv';
import pg from 'pg';


/** @type {import('./$types').PageServerLoad} */
export async function load({ locals, params }) {
    dotenv.config();
    //protects page
    if (!locals.user) {
        throw redirect(302, '/login');
    }

    const client = new pg.Client({
        user: process.env.DBUSER,
        host: process.env.DB_HOST,
        database: 'safe_call',
        password: process.env.DBPASSWORD,
        port: 5432,
    });
    await client.connect()
    .catch((e) => { console.error('error connecting to db: ', e); });

    //get users id (yes this should be stored in locals but shits all fucked up)
    const queryUserSql = 'SELECT * FROM users WHERE username = $1;'
    const user = await client.query(queryUserSql, [locals.user.username]);
    if (typeof user.rows[0] == "undefined") {
        throw new Error("Cant find the logged in user, something is seriously wrong 💀💀");
    }
    const userId = user.rows[0].id;

    const queryChatsSql = 
        `SELECT users_chats.*, chats.*
        FROM users_chats
        JOIN chats ON users_chats.chat_id = chats.id
        WHERE users_chats.user_id = $1;`

    const chats = await client.query(queryChatsSql, [userId]);
    let chatId;
    for (const chat of chats.rows) {
        if (chat.name === params.chat) {
            chatId = chat.id;
            break;
        }
    }

    const queryMessagesSql = 
        `SELECT users.username, messages.*
        FROM messages
        JOIN users ON users.id = messages.user_id
        WHERE messages.chat_id = $1;`

    const messages = await client.query(queryMessagesSql, [chatId]);
    messages.rows.sort((a, b) => a.time_sent - b.time_sent);

    return { 
        user: locals.user, 
        chatData: {
            name: params.chat,
            chatId: chatId,
            userId: userId,
        }, 
        messages: messages.rows 
    };
};

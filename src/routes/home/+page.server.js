import { redirect } from '@sveltejs/kit';
import pg from 'pg';
import dotenv from 'dotenv';
import { readFileSync } from 'fs';


/** @type {import('./$types').PageServerLoad} */
export async function load({ locals }) {
    dotenv.config();

    //is user logged in?!?!
    if (!locals.user) {
        throw redirect(302, './login');
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

    //query to get user id even tho it should be stored in the cookie cause shits all fucked up and cant be bothered to redo user auth code to not suck
    const queryUserSql = 'SELECT * FROM users WHERE username = $1;'
    const user = await client.query(queryUserSql, [locals.user.username]);
    if (typeof user.rows[0] == "undefined") {
        //TODO: add actual error handling
        throw new Error("Couldn't find the user, so it probably isn't real");
    }
    
    //gets users chats from 
    const queryChatsSql = 
        `SELECT users_chats.*, chats.*
        FROM users_chats
        JOIN chats ON users_chats.chat_id = chats.id
        WHERE users_chats.user_id = $1;`
    const chats = await client.query(queryChatsSql, [user.rows[0].id]);

    //add an array containing each chats users to each row
    if (chats.rows.length > 0) {
        const findUsersSql = 
            `SELECT users.*, users_chats.*
            FROM users_chats
            JOIN users ON users_chats.user_id = users.id
            WHERE users_chats.chat_id = $1;`

        for (const chat of chats.rows) {
            const members = await client.query(findUsersSql, [chat.id]);
            chat.chatMembers = members.rows; 
        }
    }
    client.end();
    return { user: locals.user, chats: (chats.rows.length > 0) ? chats.rows : [] };
}

export const actions = {
    createChat: async ({ request, locals }) => {
        const data = await request.formData();
        const userToAdd = data.get("username");
        const chatName = userToAdd; 

        const client = new pg.Client({
            user: process.env.DBUSER,
            host: process.env.DB_HOST,
            database: 'safe_call',
            password: process.env.DBPASSWORD,
            port: 5432,
        });
        await client.connect()
        .catch((e) => { console.error('error connecting to db: ', e); });

        //gets user_id for the user they tried to make the chat with
        const queryUserSql = 'SELECT * FROM users WHERE username = $1;';
        const user = await client.query(queryUserSql, [userToAdd]);
        if (typeof user.rows[0] == "undefined") {
            //TODO: make this tell the front end that it was an invalid user 
            return { error: "invalid user" };
        }
        
        //creates the chat
        const createChatSql = 'INSERT INTO chats (name) VALUES ($1) RETURNING id;';
        const chat = await client.query(createChatSql, [chatName]);
        if (typeof chat.rows[0] == "undefined") {
            throw new Error("ERROR: failed to create chat");
        }  

        //adds the forign user to the chat
        const addUserToChatSql = 'INSERT INTO users_chats (user_id, chat_id) VALUES ($1, $2);';
        const userChatRelationship = await client.query(addUserToChatSql, [user.rows[0].id, chat.rows[0].id]);
        if (typeof userChatRelationship.rowCount == 0) {
            throw new Error("ERROR: failed to add foreign user to chat");
        }
        //adds the requesting user to the chat (why this order? good quesiton)
        const secondUserChatRelationship = await client.query(addUserToChatSql, [locals.user.username, chat.rows[0].id]);
        if (secondUserChatRelationship.rowCount == 0) {
            throw new Error("ERROR: failed to add currnet user to chat");
        }
        client.end();
        return { error: null };
    }
}
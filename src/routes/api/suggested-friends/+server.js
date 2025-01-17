import dotenv from 'dotenv';
import pg from 'pg';

//amount of users returned, adjust later
const desiredUsers = 20;

async function friendsFriends(client, users, friends, requestingUser) {
    
    const getFriendsSql = 
    `SELECT 
        friendships.*, 
        user1.username as user_1_username,
        user2.username as user_2_username
    FROM friendships
    JOIN users user1 ON user1.id = friendships.user_1
    JOIN users user2 ON user2.id = friendships.user_2
    WHERE friendships.user_1 = $1 OR friendships.user_2 = $1;`

    //TODO: make it not show people your already friends with
    //TODO: make it not show duplicates

    //loops over friends and adds around desiredUsers amount of users to users
    const startingLength = users.length;
    for (let i = 0; users.length <= startingLength + desiredUsers; i++) {
        
        //friendships have 2 user ids, one for each id
        //requesting user might be either, so this sets the id which is queried for friends to be the non-requesting-user
        if (friends.rows[i].user_1 === requestingUser) {
            var userId = friends.rows[i].user_2;
        } else {
            var userId = friends.rows[i].user_1;
        }

        const friendsOfFriend = await client.query(getFriendsSql, [userId]);

        //if there friend has only 1 friends (the requesting user), skip
        if (friendsOfFriend.rowCount === 1) {
            continue;
        }

        //sets amount of users to be added from this friend to prevent the entire thing being one dudes friends, number may need to be lowered from 5
        if (friendsOfFriend.rowCount > 5) {
            var usersToBeAdded = 5;
        } else {
            var usersToBeAdded = friendsOfFriend.rowCount;
        }

        for (let a = 0; a < usersToBeAdded; a++) {
            if (friendsOfFriend.rows[a].id === requestingUser)
            users.push(friendsOfFriend.rows[a]);
        }
    }
    
}


async function randomPeople(client, users) {
    
}

//this page collects 20 users to display in the discover box, and if they scroll to the bottom, this is called again and more are lazy loaded
//it gets them in this order: 1. friends' friends, 2. friends' friends' friends, 3. random people 

export async function POST({ request, locals }) {
    dotenv.config();

    const client = new pg.Client({
        user: process.env.DBUSER,
        host: 'localhost',
        database: 'safe_call',
        password: process.env.DBPASSWORD,
        port: 5432,
    });
    await client.connect()
    .catch((e) => { console.error('error connecting to db: ', e); });


    //get user id to get friends
    const queryUserSql = 'SELECT * FROM users WHERE username = $1;'
    const user = await client.query(queryUserSql, [locals.user.username]);
    if (user.rowCount === 0) {
        //TODO: add actual error handling
        throw new Error("Couldn't find the user, so it probably isn't real");
    }

    // get users friends
    const getFriendsSql = 
    `SELECT 
        friendships.*, 
        user1.username as user_1_username,
        user2.username as user_2_username
    FROM friendships
    JOIN users user1 ON user1.id = friendships.user_1
    JOIN users user2 ON user2.id = friendships.user_2
    WHERE friendships.user_1 = $1 OR friendships.user_2 = $1;`

    const friends = await client.query(getFriendsSql, [user.rows[0].id]);

    let { users } = await request.json();
    await friendsFriends(client, users, friends, user.rows[0].id);
    if (users.length >= desiredUsers) {
        client.end();
        return new Response(JSON.stringify(users), { status: 200 });
    }

    //last resort, get random people
    await randomPeople(client, users);
    if (users.length <= desiredUsers) {
        client.end();
        return new Response(JSON.stringify({ error: 'failed to get enough randoms somehow' }), { status: 500 });
    }

    client.end();
    return new Response(JSON.stringify(users), { status: 200 });
}
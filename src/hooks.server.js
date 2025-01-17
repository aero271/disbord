import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';


export async function handle({ event, resolve }) {
    dotenv.config();
    const token = event.cookies.get('jwt');
    
    //if token is exists and is valid (meaning user is logged in) set event.locals.user to the token to the token 
    //on protected pages, load function in +page.server.js checks if locals.user is set to something
    if (token) {
    
        try {
            const user = jwt.verify(token, process.env.JWT_SECRET);
            event.locals.user = user;
        } catch (error) {
            console.error(error);
            event.locals.user = null;
        }
    } else {
        event.locals.user = null;
    }

    return await resolve(event);
}
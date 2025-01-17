
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';


export async function POST({ request, cookies }) {
    dotenv.config();
    const { username, id } = await request.json();

    const token = jwt.sign({ username, id }, process.env.JWT_SECRET, { expiresIn: '1d'});
    cookies.set('jwt', token, {
        httpOnly: true,
        //secure: true,
        sameSite: 'strict',
        maxAge: 3600 * 24, //one day
        path: '/',
    });

    return new Response(null, { status: 200 });
}
/** @type {import('./$types').RequestHandler} */
export async function GET({ cookies }) {
    cookies.set('jwt', '', {
        path: '/',
        maxAge: 0,
        httpOnly: true
    }); 
    return new Response(null, { status: 200 });
};
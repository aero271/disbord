import { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 4000 });

wss.on('connection', (ws) => {
    console.log("client connected");

    ws.on('message', (message) => {
        
        wss.clients.forEach((client) => {
            if (client != ws && client.readyState === client.OPEN)  {
                client.send(message);

            }
        });
    });

    ws.on('close', () => {
        console.log("client disconnected");
    });
});

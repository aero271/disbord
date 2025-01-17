import { WebSocketServer } from "ws";

const wss = new WebSocketServer({ port: 5000 });
console.log("hosting on 5000");

let clients = new Set();

wss.on('connection', (ws) => {
    console.log("client connected");

    ws.on('message', (data) => {
        const message = JSON.parse(data);
        console.log(message);

        ws.id = message.chatId;
        if (message.message) {
            clients.forEach((client) => {
                if (client.id == message.chatId) {
                    client.send(JSON.stringify(message.message));
                }
            });
        } else {
            clients.add(ws);
        }

    });
});

wss.on('error', (error) => {
    console.log("websocket error ", error);
});
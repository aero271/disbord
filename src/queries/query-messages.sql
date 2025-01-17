SELECT users.username, messages.*
FROM messages
JOIN users ON users.id = messages.user_id
WHERE messages.chat_id = $1;
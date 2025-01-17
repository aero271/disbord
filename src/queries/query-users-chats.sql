SELECT users_chats.*, chats.*
FROM users_chats
JOIN chats ON users_chats.chat_id = chats.id
WHERE users_chats.user_id = $1;
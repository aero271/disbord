SELECT users.*, users_chats.*
FROM users_chats
JOIN users ON users_chats.user_id = users.id
WHERE users_chats.chat_id = $1;
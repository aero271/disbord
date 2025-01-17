SELECT 
    friendships.*, 
    user1.username as user_1_username,
    user2.username as user_2_username
FROM friendships
JOIN users user1 ON user1.id = friendships.user_1
JOIN users user2 ON user2.id = friendships.user_2
WHERE friendships.user_1 = $1 OR friendships.user_2 = $1;
Задача 1

USE vk;
SELECT *
FROM messages
WHERE to_user_id = 1
GROUP BY from_user_id
ORDER BY from_user_id DESC 
LIMIT 1; 

Задача 2. 
SELECT COUNT(*) as 'Likes' FROM profiles WHERE (YEAR(NOW())-YEAR(birthday)) < 11;
 
 
/*
Задача 3.
    
SELECT 
    CASE(gender)
        WHEN 'm' THEN 'мужской'
        WHEN 'f' THEN 'женский'
        ELSE 'нет'
    END as gender
    , COUNT(*) as 'Кол-во:' FROM profiles GROUP BY gender;
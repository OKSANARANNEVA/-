DROP DATABASE IF EXISTS online_library;
CREATE DATABASE online_library;


use online_library;


DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, 
    firstname VARCHAR(100),
    lastname VARCHAR(100), 
    email VARCHAR(100) UNIQUE,
    password_hash varchar(100),
    phone BIGINT unsigned,
    INDEX users_firstname_lastname_idx(firstname, lastname),
    UNIQUE INDEX email_unique (email),
    UNIQUE INDEX phone_unique (phone)
);

   
DROP TABLE IF EXISTS books;
CREATE TABLE books (
	id serial primary key,
	name varchar(100) DEFAULT NULL,
	pages smallint DEFAULT null,
	description TEXT DEFAULT NULL, 
	rating TINYINT UNSIGNED DEFAULT NULL,
	logo VARCHAR(31) DEFAULT NULL
);	
	
DROP TABLE IF exists author;	
CREATE TABLE author (
	id SERIAL PRIMARY KEY,
	author_firstname_lastname VARCHAR(100) NOT NULL
);

DROP TABLE IF exists autor_books;	
CREATE TABLE author_books (
	book_id BIGINT UNSIGNED NOT NULL,
    author_id BIGINT UNSIGNED NOT NULL,
    published_at YEAR DEFAULT NULL,
    INDEX fk_author_books_book_idx (book_id),
    INDEX fk_author_books_category_idx (author_id),
    CONSTRAINT fk_author_books_book FOREIGN KEY (book_id) REFERENCES books (id),
    CONSTRAINT fk_author_books_author FOREIGN KEY (author_id) REFERENCES author (id),
    PRIMARY KEY (book_id, author_id)
); 



DROP TABLE IF exists categories;
CREATE TABLE categories (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL unique
);


DROP TABLE IF exists categories_books;
CREATE TABLE categories_books (
	book_id BIGINT UNSIGNED NOT NULL,
    category_id BIGINT UNSIGNED NOT NULL,
    INDEX fk_categories_books_book_idx (book_id),
    INDEX fk_categories_books_category_idx (category_id),
    CONSTRAINT fk_categories_books_book FOREIGN KEY (book_id) REFERENCES books (id),
    CONSTRAINT fk_categories_books_category FOREIGN KEY (category_id) REFERENCES categories (id),
    PRIMARY KEY (book_id, category_id)
);	

DROP TABLE IF exists reviews;
CREATE TABLE reviews (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    book_id BIGINT UNSIGNED NOT NULL,
    txt TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX fk_reviews_user_idx (user_id),
    INDEX fk_reviews_book_idx (book_id),
    CONSTRAINT fk_reviews_users_user FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_reviews_books_book FOREIGN KEY (book_id) REFERENCES books (id)
);


DROP TABLE IF exists review_likes;
CREATE TABLE review_likes (
	user_id BIGINT UNSIGNED NOT NULL,
    review_id BIGINT UNSIGNED NOT NULL,
    like_type BOOLEAN,
    INDEX fk_likes_users_idx (user_id),
    INDEX fk_likes_reviews_idx (review_id),
    CONSTRAINT fk_likes_users_user FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_likes_reviews_review FOREIGN KEY (review_id) REFERENCES reviews (id),
    PRIMARY KEY (user_id, review_id)
);

DROP TABLE IF exists rating_votes;
CREATE TABLE rating_votes (
	user_id BIGINT UNSIGNED NOT NULL,
	book_id BIGINT UNSIGNED NOT NULL,
	vote TINYINT UNSIGNED NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- возможно пригодится, чтобы давать свежим голосам больший вес
	INDEX fk_votes_author_idx (user_id),
    INDEX fk_votes_book_idx (book_id),
    CONSTRAINT fk_votes_users_user FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_votes_books_book FOREIGN KEY (book_id) REFERENCES books (id),
    PRIMARY KEY (user_id, book_id)
);


DROP TABLE IF exists users_library;
CREATE TABLE users_library (
	user_id BIGINT UNSIGNED NOT NULL,
    book_id BIGINT UNSIGNED NOT NULL,
    INDEX fk_users_library_user_idx (user_id),
    INDEX fk_users_library_book_idx (book_id),
    CONSTRAINT fk_users_library_user FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_users_library_book FOREIGN KEY (book_id) REFERENCES books (id),
    PRIMARY KEY (user_id, book_id)
);

DROP TABLE IF exists medias;
CREATE TABLE medias (
	book_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	media_type ENUM('img', 'pdf', 'file') NOT NULL,
	INDEX fk_images_books_book_idx (book_id),
    CONSTRAINT fk_images_books_book FOREIGN KEY (book_id) REFERENCES books (id)
);


INSERT INTO categories VALUES
	(1,'Современная литература'),
	(2,'Научная фантастика'),
	(3,'Приключения'),
	(4,'Экономика'),
	(5,'Поэзия'),
	(6,'Ужасы'),
	(7,'Физика'),
	(8,'Психология'),
	(9,'Фэнтези'),
	(10,'Педагогика'),
	(11,'Классики литературы'),
	(12,'Публицистика'),
	(13,'Программирование')
;

INSERT INTO author VALUES
	(1,'Михаил Булгаков'),
	(2,'Эрнест Хемингуэй'),
	(3,'Джордж Оруэлл'),
	(4,'Адам Смит'),
	(5,'Максим Горький'),
	(6,'Федор Достоевский'),
	(7,'Михаил Лермонтов'), 
	(8,'Александр Пушкин'),
	(9,'Иван Тургенев'),	
	(10,'Лев Толстой')	
;

INSERT INTO books (id,name,pages,rating, description) VALUES
	(1,'Мастер и Маргарита',450,100,'Роман «Мастер и Маргарита» – визитная карточка Михаила Афанасьевича Булгакова. Более десяти лет Булгаков работал над книгой, которая стала его романом-судьбой, романом-завещанием. В «Мастере и Маргарите» есть все: веселое озорство и щемящая печаль, романтическая любовь и колдовское наваждение, магическая тайна и безрассудная игра с нечистой силой.'),
	(2,'Старик и море',170,80,'«Старик и море». Повесть посвящена «трагическому стоицизму»: перед жестокостью мира человек, даже проигрывая, должен сохранять мужество и достоинство. Изображение яростной схватки с чудовищной рыбой, а затем с пожирающими ее акулами удачно контрастирует с размышлениями о прошлом, об окружающем мире.'),
	(3,'1984',320,55,'Одна из самых знаменитых антиутопий XX века – роман «1984» английского писателя Джорджа Оруэлла (1903–1950) был написан в 1948 году и продолжает тему «преданной революции», раскрытую в «Скотном дворе». По Оруэллу, нет и не может быть ничего ужаснее тотальной несвободы. Тоталитаризм уничтожает в человеке все духовные потребности, мысли, чувства и сам разум, оставляя лишь постоянный страх и единственный выбор – между молчанием и смертью, и если Старший Брат смотрит на тебя и заявляет, что «дважды два – пять», значит, так и есть.'),
	(4,'Исследование о природе и причинах богатства народов',1770,30,'Для научных работников, историков экономической мысли, аспирантов и студентов, а также всех интересующихся наследием классиков политической экономии.'),
	(5,'На дне',70,100,null),
	(6,'Бесы',850,68,'Знаменитый пророческий роман-предупреждение Ф.М. Достоевского (1821–1881) «Бесы» и сейчас интересен современному поколению читателей и не только как литературный шедевр. Роман-памфлет о зарождающемся терроризме и анархизме раскрывает трагедию русской души, в которой поселились бесы.'),
	(7,'Герой нашего времени',210,89,'«Герой нашего времени» – роман гениального поэта и прозаика, классика XIX века М. Ю. Лермонтова.'),
	(8,'Капитанская дочка',233,67,'«В романе «Капитанская дочка» А.С.Пушкин нарисовал яркую картину стихийного крестьянского восстания под предводительством Емельяна Пугачева.'),
	(9,'Отцы и дети',240,25,'В романе «Отцы и дети» отразилась идеологическая борьба двух поколений, являвшаяся одной из главных особенностей общественной жизни 60-х годов XIX века. Роман приобрел непреходящие общечеловеческий интерес и значение.'),
	(10,'Война и мир',1200,10,'Война и мир" – самый известный роман Льва Николаевича Толстого, как никакое другое произведение писателя, отражает глубину его мироощущения и философии.')
;

INSERT INTO categories_books VALUES
	(1, 1),(1, 2),(1, 3),
	(2, 4),(2, 5),(2, 6),
	(3, 1),(3, 2),(3, 3),
	(4, 1),(4, 3),(4, 7),
	(5, 5),(5, 7),(5, 8),
	(6, 1),(6, 2),(6, 6),
	(7, 9),(7, 10),(7, 13),
	(8, 12),(8, 1),(8, 3),
	(9, 1),(9, 3),(9, 10),
	(10, 2),(10, 6)
;

INSERT INTO author_books VALUES 
	(1,1,1967),(2,2,1952),(3,3,1949),(4,4,1940),(5,5,1902),(6,6,1972),(7,7,1945),(8,8,1941),(9,9,1961),(10,10,1963)
;

INSERT INTO medias VALUES
	(1,'img'),
	(2,'img'),
	(3,'img'),
	(4,'img'),
	(5,'img')
;

-- часть 2 (социальная)

INSERT INTO users (id,lastname,firstname,email,phone) VALUES
	(1,'Maxim','Demchenko','bot@yandex.ru','89131456784'),
	(2,'Katya','Sidorova','bot_2@yandex.ru','81234567854'),
	(3,'Дима','Медведев','bot_3@yandex.ru','89057896432'),
	(4,'Павел','Дуров','bot_4@yandex.ru','89056078543'),
	(5,'Пользователь','Пользователь','bot_5@yandex.ru','89609011075'),
	(6,'Игорь','Романов','bot_6@yandex.ru','89511668456'),
	(7,'Женя','Киров','bot_7@yandex.ru','89077775787')
;


INSERT INTO rating_votes (user_id, book_id, vote) values
	(1,3,10), (1,2,10), (1,8,10), (1,9,10), (1,4,10),
	(2,1,7), (2,2,6), (2,5,8), (2,7,8), (2,10,3),
	(3,2,8), (3,4,6), (3,7,10), (3,9,6), (3,6,3),
	(4,1,8), (4,3,6), (4,4,8), (4,5,9), (4,7,7),
	(5,2,6), (5,3,9), (5,5,4), (5,8,7), (5,10,7),
	(6,5,8), (6,8,6), (6,9,7), (6,10,8), (6,3,4),
	(7,1,8), (7,2,8), (7,3,6), (7,4,7), (7,5,10)
; 

INSERT INTO users_library values
	(1,3), (1,4), (1,9), (1,6), (2,10),
	(2,1), (2,5), (2,8), (2,9), (2,6),
	(3,2), (3,6), (3,7), (3,9), (3,10),
	(4,1), (4,3), (4,4), (4,5), (4,10),
	(5,2), (5,3), (5,5), (5,8), (5,10),
	(6,5), (6,7), (6,8), (6,9), (6,10),
	(7,1), (7,2), (7,5), (7,7), (7,8)
;

INSERT INTO reviews (user_id, book_id, txt) VALUES
	(2,5,'Книга крутая'),
	(2,8,'Оч понравилось произведение'),
	(3,5,'Плакал в концеб, тронуло до глубины души'),
	(3,10,'Прочитал буквально за пару дней на одном дыхании'),
	(4,2,'Мне одному не понравилась'),
	(4,4,'Скукота не описуемая'),
	(5,1,'Сюжет просто восхитительный'),
	(5,2,'Персонажи подкачали'),
	(6,7,'Не ну конечно не плохо но можно было и лучше'),
	(7,2,'Еще читаю, но пока все круто'),
	(7,5,'Пока - мой топ 1'),
	(7,7,'Не советаю книга отстой')
;

INSERT INTO review_likes VALUES
	(1,4,true), (2,6,false),(2,1,true), (2,3,true), (2,10,true), (3,3,true), (3,5,true), (4,2,false), (4,8,true), (5,2,false), (5,7,true), (5,9,false), (5,10,true), (6,10,true), (7,6,true), (7,9,true)
;


USE online_library;

DROP TRIGGER IF EXISTS rating_votes_check;
DROP FUNCTION IF EXISTS get_rating;
DROP TRIGGER IF EXISTS do_vote;

DELIMITER //

/*ограничение голосования (допустимые значения 1..10)*/
CREATE TRIGGER rating_vote_check BEFORE INSERT ON rating_votes
FOR EACH ROW
BEGIN
	IF NEW.vote NOT IN (1,2,3,4,5,6,7,8,9,10) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 'Insert Canceled. Vote может принимать значения от 1 до 10';
	END IF;
END //

/*подсчет рейтинга*/
CREATE FUNCTION get_rating (id BIGINT)
RETURNS INT READS SQL DATA
BEGIN
	RETURN (SELECT ROUND(AVG(vote) * 10) FROM rating_votes WHERE book_id = id);
END //

/*проголосовать*/
CREATE TRIGGER do_vote AFTER INSERT ON rating_votes
FOR EACH ROW 
BEGIN
	UPDATE books SET rating = get_rating(NEW.book_id) WHERE id = NEW.book_id;
END

DELIMITER ;

USE online_library;

CREATE OR REPLACE VIEW books_table AS
SELECT
	books.name,
	(SELECT author_firstname_lastname FROM author WHERE id = pg.author_id) AS author,
	published_at,
	pages,
	books.description,
	rating / 10 AS rating
FROM books JOIN author_books AS pg ON books.id = pg.book_id;

SELECT * FROM books_table;


SELECT
	books.name,
	rating / 10 AS rating,
	vote,
	(select firstname FROM users WHERE user_id = id) AS user
FROM rating_votes JOIN books ON book_id = id ORDER BY name,vote;

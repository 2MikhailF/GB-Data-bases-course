DROP DATABASE IF EXISTS vk_apr;
CREATE DATABASE vk_apr;
USE vk_apr;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, -- bigint unsigned not null AUTO_INCREMENT UNIQUE
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	email VARCHAR(100) UNIQUE,
	password_hash VARCHAR(100),
	phone BIGINT UNSIGNED, -- 79266636596 

	INDEX users_phone_idx(phone),
	INDEX users_firstname_lastname_idx(first_name, last_name)

);

-- 1 к 1 связь --
DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	user_id SERIAL PRIMARY KEY,
	gender char(1) NOT NULL,
	birthday date,
	city VARCHAR(100),
	photo_id bigint UNSIGNED,
	
	created_at DATETIME DEFAULT NOW()
);

ALTER TABLE vk_apr.profiles
ADD CONSTRAINT fk_user_id
FOREIGN KEY (user_id) REFERENCES users(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;


DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_user_id  BIGINT UNSIGNED NOT NULL,
	body TEXT,
	created_at DATETIME DEFAULT NOW(),
	
	FOREIGN KEY (from_user_id) REFERENCES users(id),
	FOREIGN KEY (to_user_id) REFERENCES users(id)		
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	initiator_user_id BIGINT UNSIGNED NOT NULL,
	target_user_id BIGINT UNSIGNED NOT NULL,
	status ENUM('requested', 'approved', 'unfriended', 'declined'),
	requested_at DATETIME DEFAULT NOW(),
	confirmed_at DATETIME ON UPDATE NOW(),								-- посмотреть, в видео updated_at
	
	PRIMARY KEY (initiator_user_id, target_user_id),
	FOREIGN KEY (initiator_user_id) REFERENCES users(id),
	FOREIGN KEY (target_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150),

	INDEX communities_name_idx(name)
);


DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
	status_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	
	PRIMARY KEY (user_id, community_id),
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (status_id) REFERENCES users_statuses(id), -- к новой таблице статусов
	FOREIGN KEY (community_id) REFERENCES communities(id)
);


DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);



DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL PRIMARY KEY,
	media_type_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	body text,
    filename VARCHAR(255),
    `size` INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);


DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS photo_albums;
CREATE TABLE photo_albums (
	id SERIAL PRIMARY KEY,
	name  varchar(255) DEFAULT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS photos;
CREATE TABLE photos(
	id SERIAL PRIMARY KEY,
	albom_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,			-- все референсы фото будут храниться в таблице медиа
	
	FOREIGN KEY (albom_id) REFERENCES photo_albums(id),
	FOREIGN KEY (media_id) REFERENCES media(id)
);


-- таблица статусов пользователей в сообществах. Подозреваю, что заводить отдельную таблицу с одиним полем - лишнее. Но, тем не менее...
DROP TABLE IF EXISTS users_statuses;
CREATE TABLE users_statuses(
	id SERIAL PRIMARY KEY,	
	status ENUM('admin', 'member', 'under_review')
);	

-- таблица новостей. Новости могут создавать пользователи от себя лично, либо от  сообщества
DROP TABLE IF EXISTS news;
CREATE TABLE news(
	id SERIAL PRIMARY KEY,
	created_by_user BIGINT UNSIGNED NOT NULL,
	created_by_community BIGINT UNSIGNED,
	body TEXT,
	media BIGINT UNSIGNED,
	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
    FOREIGN KEY (created_by_user) REFERENCES users(id),
    FOREIGN KEY (created_by_community) REFERENCES communities(id),
    FOREIGN KEY (media) REFERENCES media(id)
);

-- таблица тегов, приминимая к фото, медиа, новостям. Сделаем также индекс по тегам.
DROP TABLE IF EXISTS tags;
CREATE TABLE tags(
	id SERIAL PRIMARY KEY,
	name VARCHAR (150),
	media BIGINT UNSIGNED,
	photo BIGINT UNSIGNED,
	news BIGINT UNSIGNED,
	
	FOREIGN KEY (media) REFERENCES media(id),
	FOREIGN KEY (photo) REFERENCES photos(id),
	FOREIGN KEY (news) REFERENCES news(id),
	
	INDEX tags_name_idx(name)
);


-- таблица постов. С привязкой фото, медиа и тегов.
DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  post_id SERIAL PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  head VARCHAR(100) NOT NULL,
  body TEXT NOT NULL,
  media_id BIGINT UNSIGNED,
  photo_id BIGINT UNSIGNED,
  tag BIGINT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (media_id) REFERENCES media(id),
  FOREIGN KEY (photo_id) REFERENCES photos(id),
  FOREIGN KEY (tag) REFERENCES tags(id)

);

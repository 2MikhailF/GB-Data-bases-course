

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

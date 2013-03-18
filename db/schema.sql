-- MySql schema configuration file
CREATE TABLE IF NOT EXISTS users (
    id			INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name 		VARCHAR(20) UNIQUE NOT NULL
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS hashtags (
	id			INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	tag			VARCHAR(30) UNIQUE NOT NULL
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS content_mentions (
	content_id	INT UNSIGNED NOT NULL,
	user_id		INT UNSIGNED NOT NULL, 
	INDEX(content_id),
	FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS content_hashtags (
	content_id	INT UNSIGNED NOT NULL,
	hashtag_id	INT UNSIGNED NOT NULL,
	INDEX(content_id),
	FOREIGN KEY(hashtag_id) REFERENCES hashtags(id) ON DELETE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS content_comments (
	id			INT UNSIGNED NOT NULL AUTO_INCREMEMNT PRIMARY KEY, -- may need to extend to a bigint, but for now 4.2 billion upper limit seems acceptable to scope
	user_id		INT UNSIGNED NOT NULL,
	content_id	INT UNSIGNED NOT NULL,
	text_body	VARCHAR(1000) NOT NULL,
	date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
	INDEX(content_id)
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS polls (
	id			INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id		INT UNSIGNED NOT NULL,
	question	VARCHAR(100) NOT NULL,
	text_body	VARCHAR(1000) NOT NULL,
	date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS poll_options (
	poll_id		INT UNSIGNED NOT NULL,
	option_no	INT UNSIGNED NOT NULL,
	content		VARCHAR(150) NOT NULL,
	active		VARCHAR(1) NOT NULL DEFAULT 'Y',
	FOREIGN KEY(poll_id) REFERENCES polls(id) ON DELETE CASCADE,
	PRIMARY KEY(option_no,poll_id)
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS poll_answers (
	poll_id		INT UNSIGNED NOT NULL,
	option_no	INT UNSIGNED NOT NULL,
	user_id 	INT UNSIGNED NOT NULL,
	FOREIGN KEY(poll_id,option_no) REFERENCES poll_options(poll_id,option_no) ON DELETE CASCADE,
	FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
	PRIMARY KEY(poll_id,option_no,user_id)
) Engine=InnoDB;

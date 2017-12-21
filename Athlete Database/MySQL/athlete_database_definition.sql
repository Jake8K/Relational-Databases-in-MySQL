
DROP TABLE IF EXISTS `athletes_sports`;
DROP TABLE IF EXISTS `sport_focus`;
DROP TABLE IF EXISTS `sport`;
DROP TABLE IF EXISTS `athletes`;
DROP TABLE IF EXISTS `diet`;
DROP TABLE IF EXISTS `focus`;


CREATE TABLE focus (
	id INT NOT NULL AUTO_INCREMENT,
	focus_type VARCHAR(255) NOT NULL, -- ie bodybuilding, cardio, strength, flexibility, mindfulness, weight loss, recovery, agility
	PRIMARY KEY (id),
	UNIQUE KEY (focus_type)
	-- constraint: focus type unique?
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE sport (
	id INT NOT NULL AUTO_INCREMENT,
	sport_name VARCHAR(255) NOT NULL,
	-- sport_type ?????????,
	PRIMARY KEY (id),
	UNIQUE KEY (sport_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE diet (
	id INT NOT NULL AUTO_INCREMENT,
	diet_name VARCHAR(255) NOT NULL,
	diet_type VARCHAR(255) NOT NULL, -- ie low cal, low fat, low carb, balanced, balanced high fiber, high protein, high carb, high fat, high calory
	diet_focus INT NOT NULL,
	description TEXT,
	PRIMARY KEY (id),
	UNIQUE KEY (diet_name),
 	FOREIGN KEY (diet_focus) REFERENCES focus (id)
		ON UPDATE CASCADE
		ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE athletes (
	id INT NOT NULL AUTO_INCREMENT,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	DOB DATE,
	sex VARCHAR(10),
	fitness_level INT UNSIGNED,
	athlete_focus INT NOT NULL,
	athlete_diet INT NOT NULL,
	interests TEXT,
	PRIMARY KEY (id),
	CONSTRAINT ath_foc FOREIGN KEY (athlete_focus) REFERENCES focus (id)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	FOREIGN KEY (athlete_diet) REFERENCES diet (id)
		ON UPDATE CASCADE
		ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE athletes_sports (
	a_id INT NOT NULL,
	s_id INT NOT NULL,
	-- start_date DATE NOT NULL,
	-- intensity INT, -- ?
	PRIMARY KEY (a_id, s_id),
	KEY (a_id),
	CONSTRAINT fk_ath FOREIGN KEY (a_id) REFERENCES athletes (id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT fk_sport FOREIGN KEY (s_id) REFERENCES sport (id)
		ON UPDATE CASCADE
		ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE sport_focus (
	f_id INT NOT NULL,
	s_id INT NOT NULL,
	-- skill_level INT NOT NULL, -- ?
	PRIMARY KEY ( f_id, s_id),
	KEY (f_id),
	CONSTRAINT fk_sprt FOREIGN KEY (s_id) REFERENCES sport (id)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	CONSTRAINT fk_foc FOREIGN KEY (f_id) REFERENCES focus (id)
		ON UPDATE CASCADE
		ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;






-- what sports does an athlete do??

-- what is their focus based on their sport????

-- make the schema and chart thing first, then see what I can draw from there before doing the php and shit

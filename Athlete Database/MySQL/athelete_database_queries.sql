-- what sports does an athlete do??

-- what is their focus based on their sport????

-- make the schema and chart thing first, then see what I can draw from there before doing the php and shit

LOCK TABLES focus WRITE;
/*!40000 ALTER TABLE `focus` DISABLE KEYS */;
INSERT INTO focus VALUES (1, 'bodybuilding'), (2, 'cardio'), (3, 'strength'),
(4, 'flexibility'), (5, 'agility'), (6, 'weight loss'), (7, 'recovery'),  (8, 'mindfulness');
/*!40000 ALTER TABLE `focus` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES diet WRITE;
/*!40000 ALTER TABLE `diet` DISABLE KEYS */;
INSERT INTO diet VALUES (1, 'SoCal', 'low calorie', 6, 'not the best option'), (2, 'shredded', 'low fat', 1, 'a low fat diet'),
(3, 'paleo', 'low carb', 6, 'a high risk high result short term diet'), (4, 'zen', 'balanced', 8, 'a balanced diet, ideal for maintaininga healthy lifestyle'),
(5, 'vegan delight', 'balanced – high protein', 4, 'a high protein plant based diet'), (6, 'Beastly', 'high protein', 3, 'a high protein diet for building big muscles'),
(7, 'finish line', 'high carb', 2, 'provides abundant energy for race day'),  (8, 'fuel up', 'high calorie', 5, 'energy for cardio + strength');
/*!40000 ALTER TABLE `diet` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES sport WRITE;
/*!40000 ALTER TABLE `sport` DISABLE KEYS */;
INSERT INTO sport VALUES
(1, 'swimming'), (2, 'cycling'), (3, 'running'), (4, 'resistance training'),
(5, 'HIIT'), (6, 'Yoga'), (7, 'basketball'),  (8, 'touch football'), (9, 'rugby'),
(10, 'kayaking'), (11, 'soccer'), (12, 'ski'), (13, 'snowboarding');
/*!40000 ALTER TABLE `sport` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES athletes WRITE;
/*!40000 ALTER TABLE `athletes` DISABLE KEYS */;
INSERT INTO athletes VALUES
(1, 'Jake', 'Klein', '1985-11-18', 'M', 7, 2, 4, 'triathlons, also yoga and strength training for balance'),
(2, 'Hillary', 'Jaimes', '1987-10-26', 'F', 8, 3, 6, 'bulking up for rock climbing');
/*!40000 ALTER TABLE `athletes` ENABLE KEYS */;
UNLOCK TABLES;


-- INSERT INTO sport_focus -- (focus, sport)
LOCK TABLES sport_focus WRITE;
/*!40000 ALTER TABLE `sport_focus` DISABLE KEYS */;
INSERT INTO sport_focus VALUES
(2, 1), (6, 1), (7, 1), (3, 1), (2, 2), (2, 3), (6, 3), (5, 3), (3, 4), (1, 4), (6, 4), (7, 4),
(1, 5), (6, 5), (5, 5), (3, 5), (2, 5), (4, 6), (8, 6), (7, 6), (2, 7), (5, 7), (6, 7), (7, 7), (2, 8), (5, 8), (6, 8), (7, 8), (2, 9), (5, 9), (6, 9),
(2, 10), (3, 10), (6, 10), (7, 10), (2, 11), (5, 11), (6, 11), (6, 12), (7, 12), (6, 13), (7, 13);
/*!40000 ALTER TABLE `sport_focus` ENABLE KEYS */;
UNLOCK TABLES;


-- INSERT INTO athletes_sports -- (athlete, sport)
LOCK TABLES athletes_sports WRITE;
/*!40000 ALTER TABLE `athletes_sports` DISABLE KEYS */;
INSERT INTO athletes_sports VALUES
(1, 2), (1, 3), (1, 4), (1, 6), (1, 5), (1, 10), (2, 4), (2, 1), (2, 5), (2, 6), (2, 13);
/*!40000 ALTER TABLE `athletes_sports` ENABLE KEYS */;
UNLOCK TABLES;

-- PROBLEM: too many rows bc of sports
SELECT a.first_name, a.last_name, a.DOB, a.sex, a.fitness_level, f.focus_type, d.diet_name, d.diet_type, s.sport_name
FROM athletes a
INNER JOIN focus f ON a.athlete_focus = f.id
INNER JOIN diet d ON a.athlete_diet = d.id
INNER JOIN athletes_sports a_s ON a_s.a_id = a.id
INNER JOIN sport s ON s.id = a_s.s_id;

-- athlete info  (maybe SELECT DISTINCT)
SELECT a.first_name, a.last_name, a.DOB, a.sex, a.fitness_level, f.focus_type, d.diet_name, d.diet_type, a.interests
FROM athletes a
INNER JOIN focus f ON a.athlete_focus = f.id
INNER JOIN diet d ON a.athlete_diet = d.id
SORT BY a.id;

-- find sport and sport focus info for athlete id number 1
-- PROBLEM my name repeated on every row
-- PROBLEM sports repeat bc of focus
SELECT CONCAT(a.last_name, ', ', a.first_name) AS athlete, s.sport_name AS sport, f.focus_type AS sportFocus
FROM athletes a
INNER JOIN athletes_sports a_s ON a_s.a_id = a.id
INNER JOIN sport s ON s.id = a_s.s_id
INNER JOIN sport_focus sf ON sf.s_id = s.id
INNER JOIN focus f ON sf.f_id = f.id
WHERE a.id = 1;

-- for the more complex queries (M:N) use html to displaythings the way I want
-- so athlete with his sports in a list as part of the TABLE
-- sport with all of its deppendents (focuses)
-- OR
-- each focus followed by its corresponding diets and sports

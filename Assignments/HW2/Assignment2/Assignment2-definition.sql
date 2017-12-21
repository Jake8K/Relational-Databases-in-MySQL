-- For part one of this assignment you are to make a database with the following
   -- specifications and run the following queries
-- Table creation queries should immedatley follow the drop table queries,
    -- this is to facilitate testing on my end

-- erase these tables if they exist
DROP TABLE IF EXISTS `works_on`;
DROP TABLE IF EXISTS `project`;
DROP TABLE IF EXISTS `client`;
DROP TABLE IF EXISTS `employee`;



-- Create a table called client with the following properties:
-- id - an auto incrementing integer which is the primary key
-- first_name - a varchar with a maximum length of 255 characters, cannot be null
-- last_name - a varchar with a maximum length of 255 characters, cannot be null
-- dob - a date type (you can read about it here http://dev.mysql.com/doc/refman/5.0/en/datetime.html)
-- the combination of the first_name and last_name must be unique in this table

-- client table creation query replaces this text
CREATE TABLE client (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  dob DATE,
  PRIMARY KEY  (id),
  KEY client_name (first_name, last_name)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Create a table called employee with the following properties:
-- id - an auto incrementing integer which is the primary key
-- first_name - a varchar of maximum length 255, cannot be null
-- last_name - a varchar of maximum length 255, cannot be null
-- dob - a date type
-- date_joined - a date type
-- the combination of the first_name and last_name must be unique in this table

-- employee table creation query replaces this text
CREATE TABLE employee (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  dob DATE,
  date_joined DATE,
  PRIMARY KEY  (id),
  KEY employee_name (first_name, last_name)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Create a table called project with the following properties:
-- id - an auto incrementing integer which is the primary key
-- cid - an integer which is a foreign key reference to the client table
-- name - a varchar of maximum length 255, cannot be null
-- notes - a text type
-- the name of the project should be unique in this table

-- project table creation query replaces this text
CREATE TABLE project (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  cid INT UNSIGNED NOT NULL,
  name VARCHAR(255) NOT NULL,
  notes TEXT,
  PRIMARY KEY  (id),
  KEY project_name (name),
  FOREIGN KEY (cid) REFERENCES client (id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Create a table called works_on with the following properties, this is a table
    -- representing a many-to-many relationship
-- between employees and projects:
-- eid - an integer which is a foreign key reference to employee
-- pid - an integer which is a foreign key reference to project
-- start_date - a date type
-- The primary key is a combination of eid and pid

-- works_on table creation query replaces this text
CREATE TABLE works_on (
  eid INT UNSIGNED NOT NULL,
  pid INT UNSIGNED NOT NULL,
  start_date DATE,
  FOREIGN KEY (eid) REFERENCES employee (id),
  FOREIGN KEY (pid) REFERENCES project (id),
  PRIMARY KEY  (eid, pid)
)ENGINE=InnoDB;



-- insert the following into the client table:

-- first_name: Sara
-- last_name: Smith
-- dob: 1/2/1970
INSERT INTO client (first_name, last_name, dob)
values ("Sara", "Smith", "1970-01-02");

-- first_name: David
-- last_name: Atkins
-- dob: 11/18/1979
INSERT INTO client (first_name, last_name, dob)
values ("David", "Atkins", "1979-11-18");

-- first_name: Daniel
-- last_name: Jensen
-- dob: 3/2/1985
INSERT INTO client (first_name, last_name, dob)
values ("Daniel", "Jensen", "1985-03-02");



-- insert the following into the employee table:

-- first_name: Adam
-- last_name: Lowd
-- dob: 1/2/1975
-- date_joined: 1/1/2009
INSERT INTO employee (first_name, last_name, dob, date_joined)
values ("Adam", "Lowd", "01-02-1975", "2009-01-01");

-- first_name: Michael
-- last_name: Fern
-- dob: 10/18/1980
-- date_joined: 6/5/2013
INSERT INTO employee (first_name, last_name, dob, date_joined)
values ("Michael", "Fern", "10-18-1980", "2013-06-05");

-- first_name: Deena
-- last_name: Young
-- dob: 3/21/1984
-- date_joined: 11/10/2013
INSERT INTO employee (first_name, last_name, dob, date_joined)
values ("Deena", "Young", "03-21-1984", "2013-11-10");


-- insert the following project instances into the project table
   -- (you should use a subquery to set up foriegn key referecnes,
   -- no hard coded numbers):

-- cid - reference to first_name: Sara last_name: Smith
-- name - Diamond
-- notes - Should be done by Jan 2017
INSERT INTO project (cid, name, notes) values (
 (SELECT c.id FROM client c WHERE c.first_name = "Sara" AND c.last_name = "Smith"),
 "Diamond", "Should be done by Jan 2017");

-- cid - reference to first_name: David last_name: Atkins
-- name - Eclipse
-- notes - NULL
INSERT INTO project (cid, name) values ((SELECT c.id
  FROM client c WHERE c.first_name = "David" AND c.last_name = "Atkins"), "Eclipse");

-- cid - reference to first_name: Daniel last_name: Jensen
-- name - Moon
-- notes - NULL
INSERT INTO project (cid, name) values ((SELECT c.id
  FROM client c WHERE c.first_name = "Daniel" AND c.last_name = "Jensen"), "Moon");


-- insert the following into the works_on table using subqueries to look up data as needed:

-- employee: Adam Lowd
-- project: Diamond
-- start_date: 1/1/2012
INSERT INTO works_on (eid, pid, start_date) values
   ((SELECT e.id FROM employee e WHERE e.first_name = "Adam" AND e.last_name = "Lowd"),
    (SELECT p.id FROM project p WHERE p.name = "Diamond"), "2012-01-01");


-- employee: Michael Fern
-- project: Eclipse
-- start_date: 8/8/2013
INSERT INTO works_on (eid, pid, start_date) values
   ((SELECT e.id FROM employee e WHERE e.first_name = "Michael" AND e.last_name = "Fern"),
    (SELECT p.id FROM project p WHERE p.name = "Eclipse"), "2013-8-8");

-- employee: Michael Fern
-- project: Moon
-- start_date: 9/11/2014
INSERT INTO works_on (eid, pid, start_date) values
   ((SELECT e.id FROM employee e WHERE e.first_name = "Michael" AND e.last_name = "Fern"),
    (SELECT p.id FROM project p WHERE p.name = "Moon"), "2014-09-11");

USE `essentialmode`;

INSERT INTO `job_grades` (job_name, grade, name, label, salary) VALUES
	('hacker',0,'noob','N00b',20),
	('hacker',1,'scriptkid','Script Kiddie',40),
	('hacker',2,'pentester','Medecin-chef',60),
	('hacker',3,'boss','Chirurgien',80)
;

INSERT INTO `jobs` (name, label) VALUES
	('ambulance','Ambulance')
;

INSERT INTO `items` (name, label, `limit`) VALUES
	('bandage','Bandage', 20),
	('medikit','Medikit', 5)
;

ALTER TABLE `users`
	ADD `is_dead` TINYINT(1) NULL DEFAULT '0'
;

-- Comment this out if you don't use shops
INSERT INTO `shops` (store, item, price) VALUES
	('TwentyFourSeven','bandage',100),
	('TwentyFourSeven','medikit',150),
	('LTDgasoline','bandage',30),
	('LTDgasoline','medikit',15)
;

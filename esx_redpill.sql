USE `es_extended`;

INSERT INTO `jobs` (name, label)
VALUES ('hacker', 'Hacker')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female)
VALUES ('hacker', 0, 'noob', 'N00b', 20, '{}', '{}'),
       ('hacker', 1, 'scriptkid', 'Script Kiddie', 40, '{}', '{}'),
       ('hacker', 2, 'developer', 'Developer', 60, '{}', '{}'),
       ('hacker', 3, 'pentester', 'Pentester', 60, '{}', '{}'),
       ('hacker', 4, 'whitehat', 'White Hat', 60, '{}', '{}'),
       ('hacker', 5, 'blackhat', 'Black Hat', 60, '{}', '{}'),
       ('hacker', 6, 'greyhat', 'Grey Hat', 60, '{}', '{}'),
       ('hacker', 7, 'boss', 'The Oracle', 80, '{}', '{}')
;

INSERT INTO `items` (name, label)
VALUES ('usbdrive', 'USB Drive'),
       ('sdcard', 'SD Card')
;

-- comment this out if you don't use shops
INSERT INTO `shops` (store, item, price)
VALUES ('TwentyFourSeven', 'usbdrive', 200),
       ('TwentyFourSeven', 'sdcard', 100),
       ('LTDgasoline', 'sdcard', 100)
;

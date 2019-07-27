USE `essentialmode`;

INSERT INTO `jobs` (name, label)
VALUES ('hacker', 'Hacker')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female)
VALUES ('hacker', 0, 'noob', 'N00b', 20, '{}', '{}'),
       ('hacker', 1, 'scriptkid', 'Script Kiddie', 40, '{}', '{}'),
       ('hacker', 2, 'pentester', 'Pentester', 60, '{}', '{}'),
       ('hacker', 3, 'boss', 'The Oracle', 80, '{}', '{}')
;

INSERT INTO `items` (name, label, `limit`)
VALUES ('usbdrive', 'USB Drive', 20),
       ('sdcard', 'SD Card', 5)
;

-- comment this out if you don't use shops
INSERT INTO `shops` (store, item, price)
VALUES ('TwentyFourSeven', 'usbdrive', 200),
       ('TwentyFourSeven', 'sdcard', 100),
       ('LTDgasoline', 'sdcard', 100)
;

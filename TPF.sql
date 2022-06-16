/* RUN THIS IN HeidiSQL */

CREATE TABLE `users_identifiers` (
	`steamname` VARCHAR(40) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`steamid` VARCHAR(40) NOT NULL COLLATE 'utf8mb4_general_ci',
	`license` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`discord` VARCHAR(40) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`fivem` VARCHAR(40) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`ip` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`steamid`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `users_information` (
	`steamname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`steamid` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`lastpos` VARCHAR(255) NULL DEFAULT '{-267.7795, -958.5611, 31.2232, 209.5125}' COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`steamid`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

/* ONLY USE THIS TO EDIT THE DEFAULT SPAWNING LOCATION
If you didn't change it before executing the CREATE TABLE above and don't want to lose information you have. 
*/
/* Also, remember to have commas between x, y, z, heading */
/*
ALTER TABLE `users_information`
	CHANGE COLUMN `lastpos` `lastpos` VARCHAR(255) NULL DEFAULT '{COORDINATES, GOES, HERE, HEADING}' COLLATE 'utf8mb4_general_ci' AFTER `steamid`;
COPY FROM "ALTER TABLE" TO "AFTER `steamid`;" and change the coordinates to edit the tables lastpos
*/
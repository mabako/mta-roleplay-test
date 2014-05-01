CREATE TABLE `clothing` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `skin` int(11) unsigned NOT NULL,
  `url` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `price` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `mta`.`characters` 
	ADD COLUMN `clothingid` INT UNSIGNED NULL DEFAULT NULL;

CREATE TABLE IF NOT EXISTS `carthief` (
  `identifier` varchar(255) CHARACTER SET utf8 NOT NULL,
  `timeleft` INT(5) DEFAULT b'0',
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
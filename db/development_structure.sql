CREATE TABLE `ci_country_names` (
  `country_name_id` int(11) NOT NULL auto_increment,
  `iso_3166_1_a2_code` varchar(2) default NULL,
  `english_name` varchar(255) default NULL,
  `underlined_english_name` varchar(255) default NULL,
  PRIMARY KEY  (`country_name_id`),
  KEY `index_ci_country_names_on_iso_3166_1_a2_code` (`iso_3166_1_a2_code`),
  KEY `index_ci_country_names_on_english_name` (`english_name`),
  KEY `index_ci_country_names_on_underlined_english_name` (`underlined_english_name`)
) ENGINE=MyISAM AUTO_INCREMENT=15000 DEFAULT CHARSET=latin1;

CREATE TABLE `ci_people` (
  `person_id` int(11) NOT NULL auto_increment,
  `version` int(11) default NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`person_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15000 DEFAULT CHARSET=latin1;

CREATE TABLE `ci_person_versions` (
  `person_version_id` int(11) NOT NULL auto_increment,
  `persion_id` int(11) default NULL,
  `version` int(11) default NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`person_version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15000 DEFAULT CHARSET=latin1;

CREATE TABLE `ci_schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ci_us_states` (
  `us_state_id` int(11) NOT NULL auto_increment,
  `abbreviation` varchar(2) default NULL,
  `name` varchar(50) default NULL,
  `underlined_name` varchar(50) default NULL,
  PRIMARY KEY  (`us_state_id`),
  KEY `index_ci_us_states_on_abbreviation` (`abbreviation`),
  KEY `index_ci_us_states_on_name` (`name`),
  KEY `index_ci_us_states_on_underlined_name` (`underlined_name`)
) ENGINE=MyISAM AUTO_INCREMENT=15000 DEFAULT CHARSET=latin1;

CREATE TABLE `ci_users` (
  `user_id` int(11) NOT NULL auto_increment,
  `email` varchar(255) default NULL,
  `person_id` int(11) default NULL,
  `admin` tinyint(1) default '0',
  `state` varchar(12) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `password_reset_code` varchar(40) default NULL,
  `activation_code` varchar(40) default NULL,
  `activated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  `last_login_at` datetime default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`user_id`),
  KEY `index_ci_users_on_email` (`email`),
  KEY `index_ci_users_on_person_id` (`person_id`),
  KEY `index_ci_users_on_state` (`state`),
  KEY `index_ci_users_on_password_reset_code` (`password_reset_code`),
  KEY `index_ci_users_on_activation_code` (`activation_code`)
) ENGINE=MyISAM AUTO_INCREMENT=15001 DEFAULT CHARSET=latin1;

INSERT INTO ci_schema_migrations (version) VALUES ('20081216170645');

INSERT INTO ci_schema_migrations (version) VALUES ('20081216172545');

INSERT INTO ci_schema_migrations (version) VALUES ('20081216172610');

INSERT INTO ci_schema_migrations (version) VALUES ('20081216174522');
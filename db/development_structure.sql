CREATE TABLE `ci_country_names` (
  `country_name_id` int(11) NOT NULL AUTO_INCREMENT,
  `iso_3166_1_a2_code` char(2) DEFAULT NULL,
  `english_name` varchar(255) DEFAULT NULL,
  `underlined_english_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`country_name_id`),
  KEY `iso_index` (`iso_3166_1_a2_code`),
  KEY `english_name_index` (`english_name`(10))
) ENGINE=MyISAM AUTO_INCREMENT=1245 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_email_versions` (
  `email_version_id` int(11) NOT NULL AUTO_INCREMENT,
  `email_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `for_entity_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`email_version_id`),
  KEY `index_ci_email_versions_on_email_id` (`email_id`),
  KEY `index_ci_email_versions_on_for_entity_id` (`for_entity_id`),
  KEY `index_ci_email_versions_on_address` (`address`)
) ENGINE=MyISAM AUTO_INCREMENT=15508 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_emails` (
  `email_id` int(11) NOT NULL AUTO_INCREMENT,
  `version` int(11) DEFAULT NULL,
  `for_entity_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`email_id`),
  KEY `index_ci_emails_on_for_entity_id` (`for_entity_id`),
  KEY `index_ci_emails_on_address` (`address`)
) ENGINE=MyISAM AUTO_INCREMENT=15498 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_event_entries` (
  `event_entry_id` int(11) NOT NULL AUTO_INCREMENT,
  `version` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `cost` text,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `owner_user_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `email_id` int(11) DEFAULT NULL,
  `phone_number_id` int(11) DEFAULT NULL,
  `url_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `studio_id` int(11) DEFAULT NULL,
  `ci_notes` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`event_entry_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15103 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_event_entry_versions` (
  `event_entry_version_id` int(11) NOT NULL AUTO_INCREMENT,
  `event_entry_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `cost` text,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `owner_user_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `email_id` int(11) DEFAULT NULL,
  `phone_number_id` int(11) DEFAULT NULL,
  `url_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `studio_id` int(11) DEFAULT NULL,
  `ci_notes` text,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`event_entry_version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15183 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_jam_entries` (
  `jam_entry_id` int(11) NOT NULL AUTO_INCREMENT,
  `version` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `schedule` text,
  `cost` text,
  `owner_user_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `email_id` int(11) DEFAULT NULL,
  `phone_number_id` int(11) DEFAULT NULL,
  `url_id` int(11) DEFAULT NULL,
  `studio_id` int(11) DEFAULT NULL,
  `ci_notes` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`jam_entry_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15087 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_jam_entry_versions` (
  `jam_entry_version_id` int(11) NOT NULL AUTO_INCREMENT,
  `jam_entry_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `schedule` text,
  `cost` text,
  `owner_user_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `email_id` int(11) DEFAULT NULL,
  `phone_number_id` int(11) DEFAULT NULL,
  `url_id` int(11) DEFAULT NULL,
  `studio_id` int(11) DEFAULT NULL,
  `ci_notes` text,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`jam_entry_version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15219 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_location_versions` (
  `location_version_id` int(11) NOT NULL AUTO_INCREMENT,
  `location_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `street_address_line_1` varchar(255) DEFAULT NULL,
  `street_address_line_2` varchar(255) DEFAULT NULL,
  `city_name` varchar(255) DEFAULT NULL,
  `region_name` varchar(255) DEFAULT NULL,
  `us_state_id` int(11) DEFAULT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `country_name_id` int(11) DEFAULT NULL,
  `lat` float DEFAULT NULL,
  `lng` float DEFAULT NULL,
  `geocode_precision` varchar(10) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`location_version_id`),
  KEY `index_ci_location_versions_on_location_id` (`location_id`),
  KEY `index_ci_location_versions_on_us_state_id` (`us_state_id`),
  KEY `index_ci_location_versions_on_country_name_id` (`country_name_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15586 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_locations` (
  `location_id` int(11) NOT NULL AUTO_INCREMENT,
  `version` int(11) DEFAULT NULL,
  `street_address_line_1` varchar(255) DEFAULT NULL,
  `street_address_line_2` varchar(255) DEFAULT NULL,
  `city_name` varchar(255) DEFAULT NULL,
  `region_name` varchar(255) DEFAULT NULL,
  `us_state_id` int(11) DEFAULT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `country_name_id` int(11) DEFAULT NULL,
  `lat` float DEFAULT NULL,
  `lng` float DEFAULT NULL,
  `geocode_precision` varchar(10) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`location_id`),
  KEY `index_ci_locations_on_us_state_id` (`us_state_id`),
  KEY `index_ci_locations_on_country_name_id` (`country_name_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15280 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_organization_entries` (
  `organization_entry_id` int(11) NOT NULL AUTO_INCREMENT,
  `version` int(11) DEFAULT NULL,
  `description` text,
  `teaches_contact` tinyint(1) DEFAULT NULL,
  `studio_space` tinyint(1) DEFAULT NULL,
  `owner_user_id` int(11) DEFAULT NULL,
  `organization_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `email_id` int(11) DEFAULT NULL,
  `phone_number_id` int(11) DEFAULT NULL,
  `url_id` int(11) DEFAULT NULL,
  `ci_notes` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`organization_entry_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15026 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_organization_entry_versions` (
  `organization_entry_version_id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_entry_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `description` text,
  `teaches_contact` tinyint(1) DEFAULT NULL,
  `studio_space` tinyint(1) DEFAULT NULL,
  `owner_user_id` int(11) DEFAULT NULL,
  `organization_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `email_id` int(11) DEFAULT NULL,
  `phone_number_id` int(11) DEFAULT NULL,
  `url_id` int(11) DEFAULT NULL,
  `ci_notes` text,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`organization_entry_version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15026 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_organization_versions` (
  `organization_version_id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`organization_version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15037 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_organizations` (
  `organization_id` int(11) NOT NULL AUTO_INCREMENT,
  `version` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`organization_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15026 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_people` (
  `person_id` int(11) NOT NULL AUTO_INCREMENT,
  `version` int(11) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`person_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15489 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_person_entries` (
  `person_entry_id` int(11) NOT NULL AUTO_INCREMENT,
  `version` int(11) DEFAULT NULL,
  `description` text,
  `teaches_contact` tinyint(1) DEFAULT NULL,
  `owner_user_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `email_id` int(11) DEFAULT NULL,
  `phone_number_id` int(11) DEFAULT NULL,
  `url_id` int(11) DEFAULT NULL,
  `studio_id` int(11) DEFAULT NULL,
  `ci_notes` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`person_entry_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15070 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_person_entry_versions` (
  `person_entry_version_id` int(11) NOT NULL AUTO_INCREMENT,
  `person_entry_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `description` text,
  `teaches_contact` tinyint(1) DEFAULT NULL,
  `owner_user_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `email_id` int(11) DEFAULT NULL,
  `phone_number_id` int(11) DEFAULT NULL,
  `url_id` int(11) DEFAULT NULL,
  `studio_id` int(11) DEFAULT NULL,
  `ci_notes` text,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`person_entry_version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15070 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_person_versions` (
  `person_version_id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`person_version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15505 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_phone_number_versions` (
  `phone_number_version_id` int(11) NOT NULL AUTO_INCREMENT,
  `phone_number_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `for_entity_id` int(11) DEFAULT NULL,
  `number` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`phone_number_version_id`),
  KEY `index_ci_phone_number_versions_on_phone_number_id` (`phone_number_id`),
  KEY `index_ci_phone_number_versions_on_for_entity_id` (`for_entity_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15217 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_phone_numbers` (
  `phone_number_id` int(11) NOT NULL AUTO_INCREMENT,
  `version` int(11) DEFAULT NULL,
  `for_entity_id` int(11) DEFAULT NULL,
  `number` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`phone_number_id`),
  KEY `index_ci_phone_numbers_on_for_entity_id` (`for_entity_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15205 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ci_url_versions` (
  `url_version_id` int(11) NOT NULL AUTO_INCREMENT,
  `url_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `for_entity_id` int(11) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`url_version_id`),
  KEY `index_ci_url_versions_on_url_id` (`url_id`),
  KEY `index_ci_url_versions_on_for_entity_id` (`for_entity_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15221 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_urls` (
  `url_id` int(11) NOT NULL AUTO_INCREMENT,
  `version` int(11) DEFAULT NULL,
  `for_entity_id` int(11) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`url_id`),
  KEY `index_ci_urls_on_for_entity_id` (`for_entity_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15204 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_us_states` (
  `us_state_id` int(11) NOT NULL AUTO_INCREMENT,
  `abbreviation` char(2) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `underlined_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`us_state_id`),
  KEY `abbreviation_index` (`abbreviation`),
  KEY `name_index` (`name`(10))
) ENGINE=MyISAM AUTO_INCREMENT=1059 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_user_account_requests` (
  `user_account_request_id` int(11) NOT NULL AUTO_INCREMENT,
  `state` varchar(12) DEFAULT NULL,
  `something_about_contact_improv` text,
  `existing_entries` text,
  `ci_notes` text,
  `person_id` int(11) DEFAULT NULL,
  `email_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`user_account_request_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15256 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `own_person_entry_id` int(11) DEFAULT NULL,
  `admin` tinyint(1) DEFAULT '0',
  `state` varchar(12) DEFAULT NULL,
  `crypted_password` varchar(40) DEFAULT NULL,
  `salt` varchar(40) DEFAULT NULL,
  `password_reset_code` varchar(40) DEFAULT NULL,
  `activation_code` varchar(40) DEFAULT NULL,
  `activated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `remember_token` varchar(255) DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `index_ci_users_on_email` (`email`),
  KEY `index_ci_users_on_person_id` (`person_id`),
  KEY `index_ci_users_on_state` (`state`),
  KEY `index_ci_users_on_password_reset_code` (`password_reset_code`),
  KEY `index_ci_users_on_activation_code` (`activation_code`)
) ENGINE=MyISAM AUTO_INCREMENT=15211 DEFAULT CHARSET=utf8;

INSERT INTO ci_schema_migrations (version) VALUES ('20081216170645');

INSERT INTO ci_schema_migrations (version) VALUES ('20081216172545');

INSERT INTO ci_schema_migrations (version) VALUES ('20081216172610');

INSERT INTO ci_schema_migrations (version) VALUES ('20081216174522');

INSERT INTO ci_schema_migrations (version) VALUES ('20081216185405');

INSERT INTO ci_schema_migrations (version) VALUES ('20081216194845');

INSERT INTO ci_schema_migrations (version) VALUES ('20081216200339');

INSERT INTO ci_schema_migrations (version) VALUES ('20081216201129');

INSERT INTO ci_schema_migrations (version) VALUES ('20081216204531');

INSERT INTO ci_schema_migrations (version) VALUES ('20081216222210');

INSERT INTO ci_schema_migrations (version) VALUES ('20081216222634');

INSERT INTO ci_schema_migrations (version) VALUES ('20081217000434');

INSERT INTO ci_schema_migrations (version) VALUES ('20090108001853');

INSERT INTO ci_schema_migrations (version) VALUES ('20090108205118');

INSERT INTO ci_schema_migrations (version) VALUES ('20090110165932');

INSERT INTO ci_schema_migrations (version) VALUES ('20090110170052');

INSERT INTO ci_schema_migrations (version) VALUES ('20090112234209');

INSERT INTO ci_schema_migrations (version) VALUES ('20090112235045');

INSERT INTO ci_schema_migrations (version) VALUES ('20090117223136');

INSERT INTO ci_schema_migrations (version) VALUES ('20090118155157');

INSERT INTO ci_schema_migrations (version) VALUES ('20090118172825');

INSERT INTO ci_schema_migrations (version) VALUES ('20090118174147');

INSERT INTO ci_schema_migrations (version) VALUES ('20090126191118');
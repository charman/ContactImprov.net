CREATE TABLE `ci_companies` (
  `company_id` int(11) NOT NULL auto_increment,
  `version` int(11) default NULL,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`company_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15000 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_company_entries` (
  `company_entry_id` int(11) NOT NULL auto_increment,
  `version` int(11) default NULL,
  `description` text,
  `owner_user_id` int(11) default NULL,
  `company_id` int(11) default NULL,
  `location_id` int(11) default NULL,
  `email_id` int(11) default NULL,
  `phone_number_id` int(11) default NULL,
  `url_id` int(11) default NULL,
  `studio_id` int(11) default NULL,
  `ci_notes` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`company_entry_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15000 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_company_entry_versions` (
  `company_entry_version_id` int(11) NOT NULL auto_increment,
  `company_entry_id` int(11) default NULL,
  `version` int(11) default NULL,
  `description` text,
  `owner_user_id` int(11) default NULL,
  `company_id` int(11) default NULL,
  `location_id` int(11) default NULL,
  `email_id` int(11) default NULL,
  `phone_number_id` int(11) default NULL,
  `url_id` int(11) default NULL,
  `studio_id` int(11) default NULL,
  `ci_notes` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`company_entry_version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15000 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_company_versions` (
  `company_version_id` int(11) NOT NULL auto_increment,
  `company_id` int(11) default NULL,
  `version` int(11) default NULL,
  `name` varchar(255) default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`company_version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15000 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_country_names` (
  `country_name_id` int(11) NOT NULL auto_increment,
  `iso_3166_1_a2_code` char(2) default NULL,
  `english_name` varchar(255) default NULL,
  `underlined_english_name` varchar(255) default NULL,
  PRIMARY KEY  (`country_name_id`),
  KEY `iso_index` (`iso_3166_1_a2_code`),
  KEY `english_name_index` (`english_name`(10))
) ENGINE=MyISAM AUTO_INCREMENT=1245 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_email_versions` (
  `email_version_id` int(11) NOT NULL auto_increment,
  `email_id` int(11) default NULL,
  `version` int(11) default NULL,
  `for_entity_id` int(11) default NULL,
  `position` int(11) default NULL,
  `address` varchar(255) default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`email_version_id`),
  KEY `index_ci_email_versions_on_email_id` (`email_id`),
  KEY `index_ci_email_versions_on_for_entity_id` (`for_entity_id`),
  KEY `index_ci_email_versions_on_address` (`address`)
) ENGINE=MyISAM AUTO_INCREMENT=15001 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_emails` (
  `email_id` int(11) NOT NULL auto_increment,
  `version` int(11) default NULL,
  `for_entity_id` int(11) default NULL,
  `position` int(11) default NULL,
  `address` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`email_id`),
  KEY `index_ci_emails_on_for_entity_id` (`for_entity_id`),
  KEY `index_ci_emails_on_address` (`address`)
) ENGINE=MyISAM AUTO_INCREMENT=15001 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_event_entries` (
  `event_entry_id` int(11) NOT NULL auto_increment,
  `version` int(11) default NULL,
  `title` varchar(255) default NULL,
  `description` text,
  `cost` text,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `owner_user_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `location_id` int(11) default NULL,
  `email_id` int(11) default NULL,
  `phone_number_id` int(11) default NULL,
  `url_id` int(11) default NULL,
  `company_id` int(11) default NULL,
  `studio_id` int(11) default NULL,
  `ci_notes` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`event_entry_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15001 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_event_entry_versions` (
  `event_entry_version_id` int(11) NOT NULL auto_increment,
  `event_entry_id` int(11) default NULL,
  `version` int(11) default NULL,
  `title` varchar(255) default NULL,
  `description` text,
  `cost` text,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `owner_user_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `location_id` int(11) default NULL,
  `email_id` int(11) default NULL,
  `phone_number_id` int(11) default NULL,
  `url_id` int(11) default NULL,
  `company_id` int(11) default NULL,
  `studio_id` int(11) default NULL,
  `ci_notes` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`event_entry_version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15001 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_jam_entries` (
  `jam_entry_id` int(11) NOT NULL auto_increment,
  `version` int(11) default NULL,
  `title` varchar(255) default NULL,
  `description` text,
  `schedule` text,
  `cost` text,
  `owner_user_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `location_id` int(11) default NULL,
  `email_id` int(11) default NULL,
  `phone_number_id` int(11) default NULL,
  `url_id` int(11) default NULL,
  `studio_id` int(11) default NULL,
  `ci_notes` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`jam_entry_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15001 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_jam_entry_versions` (
  `jam_entry_version_id` int(11) NOT NULL auto_increment,
  `jam_entry_id` int(11) default NULL,
  `version` int(11) default NULL,
  `title` varchar(255) default NULL,
  `description` text,
  `schedule` text,
  `cost` text,
  `owner_user_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `location_id` int(11) default NULL,
  `email_id` int(11) default NULL,
  `phone_number_id` int(11) default NULL,
  `url_id` int(11) default NULL,
  `studio_id` int(11) default NULL,
  `ci_notes` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`jam_entry_version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15001 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_location_versions` (
  `location_version_id` int(11) NOT NULL auto_increment,
  `location_id` int(11) default NULL,
  `version` int(11) default NULL,
  `street_address_line_1` varchar(255) default NULL,
  `street_address_line_2` varchar(255) default NULL,
  `city_name` varchar(255) default NULL,
  `region_name` varchar(255) default NULL,
  `us_state_id` int(11) default NULL,
  `postal_code` varchar(255) default NULL,
  `country_name_id` int(11) default NULL,
  `lat` float default NULL,
  `lng` float default NULL,
  `geocode_precision` varchar(10) default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`location_version_id`),
  KEY `index_ci_location_versions_on_location_id` (`location_id`),
  KEY `index_ci_location_versions_on_us_state_id` (`us_state_id`),
  KEY `index_ci_location_versions_on_country_name_id` (`country_name_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15002 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_locations` (
  `location_id` int(11) NOT NULL auto_increment,
  `version` int(11) default NULL,
  `street_address_line_1` varchar(255) default NULL,
  `street_address_line_2` varchar(255) default NULL,
  `city_name` varchar(255) default NULL,
  `region_name` varchar(255) default NULL,
  `us_state_id` int(11) default NULL,
  `postal_code` varchar(255) default NULL,
  `country_name_id` int(11) default NULL,
  `lat` float default NULL,
  `lng` float default NULL,
  `geocode_precision` varchar(10) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`location_id`),
  KEY `index_ci_locations_on_us_state_id` (`us_state_id`),
  KEY `index_ci_locations_on_country_name_id` (`country_name_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15002 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_organization_versions` (
  `organization_version_id` int(11) NOT NULL auto_increment,
  `organization_id` int(11) default NULL,
  `version` int(11) default NULL,
  `name` varchar(255) default NULL,
  `description` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`organization_version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15000 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_organizations` (
  `organization_id` int(11) NOT NULL auto_increment,
  `version` int(11) default NULL,
  `name` varchar(255) default NULL,
  `description` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`organization_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15000 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_people` (
  `person_id` int(11) NOT NULL auto_increment,
  `version` int(11) default NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`person_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15003 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_person_entries` (
  `person_entry_id` int(11) NOT NULL auto_increment,
  `version` int(11) default NULL,
  `description` text,
  `owner_user_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `location_id` int(11) default NULL,
  `email_id` int(11) default NULL,
  `phone_number_id` int(11) default NULL,
  `url_id` int(11) default NULL,
  `studio_id` int(11) default NULL,
  `ci_notes` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`person_entry_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15000 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_person_entry_versions` (
  `person_entry_version_id` int(11) NOT NULL auto_increment,
  `person_entry_id` int(11) default NULL,
  `version` int(11) default NULL,
  `description` text,
  `owner_user_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `location_id` int(11) default NULL,
  `email_id` int(11) default NULL,
  `phone_number_id` int(11) default NULL,
  `url_id` int(11) default NULL,
  `studio_id` int(11) default NULL,
  `ci_notes` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`person_entry_version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15000 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_person_versions` (
  `person_version_id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `version` int(11) default NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`person_version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15003 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_phone_number_versions` (
  `phone_number_version_id` int(11) NOT NULL auto_increment,
  `phone_number_id` int(11) default NULL,
  `version` int(11) default NULL,
  `for_entity_id` int(11) default NULL,
  `number` varchar(255) default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`phone_number_version_id`),
  KEY `index_ci_phone_number_versions_on_phone_number_id` (`phone_number_id`),
  KEY `index_ci_phone_number_versions_on_for_entity_id` (`for_entity_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15001 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_phone_numbers` (
  `phone_number_id` int(11) NOT NULL auto_increment,
  `version` int(11) default NULL,
  `for_entity_id` int(11) default NULL,
  `number` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`phone_number_id`),
  KEY `index_ci_phone_numbers_on_for_entity_id` (`for_entity_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15001 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ci_studio_entries` (
  `studio_entry_id` int(11) NOT NULL auto_increment,
  `version` int(11) default NULL,
  `description` text,
  `owner_user_id` int(11) default NULL,
  `studio_id` int(11) default NULL,
  `location_id` int(11) default NULL,
  `email_id` int(11) default NULL,
  `phone_number_id` int(11) default NULL,
  `url_id` int(11) default NULL,
  `ci_notes` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`studio_entry_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15000 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_studio_entry_versions` (
  `studio_entry_version_id` int(11) NOT NULL auto_increment,
  `studio_entry_id` int(11) default NULL,
  `version` int(11) default NULL,
  `description` text,
  `owner_user_id` int(11) default NULL,
  `studio_id` int(11) default NULL,
  `location_id` int(11) default NULL,
  `email_id` int(11) default NULL,
  `phone_number_id` int(11) default NULL,
  `url_id` int(11) default NULL,
  `ci_notes` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`studio_entry_version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15000 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_studio_versions` (
  `studio_version_id` int(11) NOT NULL auto_increment,
  `studio_id` int(11) default NULL,
  `version` int(11) default NULL,
  `name` varchar(255) default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`studio_version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15000 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_studios` (
  `studio_id` int(11) NOT NULL auto_increment,
  `version` int(11) default NULL,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`studio_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15000 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_url_versions` (
  `url_version_id` int(11) NOT NULL auto_increment,
  `url_id` int(11) default NULL,
  `version` int(11) default NULL,
  `for_entity_id` int(11) default NULL,
  `address` varchar(255) default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`url_version_id`),
  KEY `index_ci_url_versions_on_url_id` (`url_id`),
  KEY `index_ci_url_versions_on_for_entity_id` (`for_entity_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15001 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_urls` (
  `url_id` int(11) NOT NULL auto_increment,
  `version` int(11) default NULL,
  `for_entity_id` int(11) default NULL,
  `address` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`url_id`),
  KEY `index_ci_urls_on_for_entity_id` (`for_entity_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15001 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_us_states` (
  `us_state_id` int(11) NOT NULL auto_increment,
  `abbreviation` char(2) default NULL,
  `name` varchar(50) default NULL,
  `underlined_name` varchar(255) default NULL,
  PRIMARY KEY  (`us_state_id`),
  KEY `abbreviation_index` (`abbreviation`),
  KEY `name_index` (`name`(10))
) ENGINE=MyISAM AUTO_INCREMENT=1059 DEFAULT CHARSET=utf8;

CREATE TABLE `ci_user_account_requests` (
  `user_account_request_id` int(11) NOT NULL auto_increment,
  `state` varchar(12) default NULL,
  `something_about_contact_improv` text,
  `existing_entries` text,
  `ci_notes` text,
  `person_id` int(11) default NULL,
  `email_id` int(11) default NULL,
  `location_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`user_account_request_id`)
) ENGINE=MyISAM AUTO_INCREMENT=15000 DEFAULT CHARSET=utf8;

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
) ENGINE=MyISAM AUTO_INCREMENT=15002 DEFAULT CHARSET=utf8;

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
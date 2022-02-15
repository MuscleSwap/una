SET @sName = 'bx_timeline';

-- TABLES
CREATE TABLE IF NOT EXISTS `bx_timeline_events` (
  `id` int(11) NOT NULL auto_increment,
  `owner_id` int(11) NOT NULL default '0',
  `system` tinyint(4) NOT NULL default '1',
  `type` varchar(255) NOT NULL,
  `action` varchar(255) NOT NULL,
  `object_id` int(11) NOT NULL default '0',
  `object_owner_id` int(11) NOT NULL default '0',
  `object_privacy_view` varchar(16) NOT NULL default '3',
  `object_cf` int(11) NOT NULL default '1',
  `content` text NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `location` text NOT NULL,
  `views` int(11) unsigned NOT NULL default '0',
  `rate` float NOT NULL default '0',
  `votes` int(11) unsigned NOT NULL default '0',
  `rrate` float NOT NULL default '0',
  `rvotes` int(11) NOT NULL default '0',
  `score` int(11) NOT NULL default '0',
  `sc_up` int(11) NOT NULL default '0',
  `sc_down` int(11) NOT NULL default '0',
  `comments` int(11) unsigned NOT NULL default '0',
  `reports` int(11) unsigned NOT NULL default '0',
  `reposts` int(11) unsigned NOT NULL default '0',
  `date` int(11) NOT NULL default '0',
  `published` int(11) NOT NULL default '0',
  `status` enum ('active', 'awaiting', 'failed', 'hidden', 'deleted') NOT NULL DEFAULT 'active',
  `status_admin` enum('active','hidden','pending') NOT NULL DEFAULT 'active',
  `active` tinyint(4) NOT NULL default '1',
  `pinned` int(11) NOT NULL default '0',
  `sticked` int(11) NOT NULL default '0',
  `promoted` int(11) NOT NULL default '0',
  PRIMARY KEY (`id`),
  KEY `owner_id` (`owner_id`),
  KEY `object_id` (`object_id`),
  FULLTEXT KEY `search_fields` (`title`, `description`)
);

CREATE TABLE IF NOT EXISTS `bx_timeline_handlers` (
  `id` int(11) NOT NULL auto_increment,
  `group` varchar(64) NOT NULL default '',
  `type` enum('insert','update','delete') NOT NULL DEFAULT 'insert',
  `alert_unit` varchar(64) NOT NULL default '',
  `alert_action` varchar(64) NOT NULL default '',
  `content` text NOT NULL,
  `privacy` varchar(64) NOT NULL default '',
  PRIMARY KEY  (`id`),
  UNIQUE `handler` (`group`, `type`),
  UNIQUE `alert` (`alert_unit`, `alert_action`)
);

INSERT INTO `bx_timeline_handlers`(`group`, `type`, `alert_unit`, `alert_action`, `content`) VALUES
('common_post', 'insert', 'timeline_common_post', '', ''),
('common_repost', 'insert', 'timeline_common_repost', '', ''),

('profile', 'delete', 'profile', 'delete', ''),

('comment', 'insert', 'comment', 'added', 'a:5:{s:11:"module_name";s:6:"system";s:13:"module_method";s:17:"get_timeline_post";s:12:"module_class";s:17:"TemplCmtsServices";s:9:"groupable";i:0;s:8:"group_by";s:0:"";}'),
('comment', 'update', 'comment', 'edited', ''),
('comment', 'delete', 'comment', 'deleted', '');

-- TABLE: mute
CREATE TABLE IF NOT EXISTS `bx_timeline_mute` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `initiator` int(11) NOT NULL,
  `content` int(11) NOT NULL,
  `mutual` tinyint(4) NOT NULL,
  `added` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `initiator` (`initiator`,`content`),
  KEY `content` (`content`)
);

-- TABLES: STORAGES, TRANSCODERS, UPLOADERS
CREATE TABLE IF NOT EXISTS `bx_timeline_photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(10) unsigned NOT NULL,
  `remote_id` varchar(128) NOT NULL,
  `path` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `mime_type` varchar(128) NOT NULL,
  `ext` varchar(32) NOT NULL,
  `size` bigint(20) NOT NULL,
  `added` int(11) NOT NULL,
  `modified` int(11) NOT NULL,
  `private` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `remote_id` (`remote_id`)
);

CREATE TABLE IF NOT EXISTS `bx_timeline_photos_processed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(10) unsigned NOT NULL,
  `remote_id` varchar(128) NOT NULL,
  `path` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `mime_type` varchar(128) NOT NULL,
  `ext` varchar(32) NOT NULL,
  `size` bigint(20) NOT NULL,
  `added` int(11) NOT NULL,
  `modified` int(11) NOT NULL,
  `private` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `remote_id` (`remote_id`)
);

CREATE TABLE IF NOT EXISTS `bx_timeline_photos2events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL DEFAULT '0',
  `media_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `media` (`event_id`, `media_id`)
);

CREATE TABLE IF NOT EXISTS `bx_timeline_videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(10) unsigned NOT NULL,
  `remote_id` varchar(128) NOT NULL,
  `path` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `mime_type` varchar(128) NOT NULL,
  `ext` varchar(32) NOT NULL,
  `size` bigint(20) NOT NULL,
  `dimensions` varchar(12) NOT NULL,
  `added` int(11) NOT NULL,
  `modified` int(11) NOT NULL,
  `private` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `remote_id` (`remote_id`)
);

CREATE TABLE IF NOT EXISTS `bx_timeline_videos_processed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(10) unsigned NOT NULL,
  `remote_id` varchar(128) NOT NULL,
  `path` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `mime_type` varchar(128) NOT NULL,
  `ext` varchar(32) NOT NULL,
  `size` bigint(20) NOT NULL,
  `added` int(11) NOT NULL,
  `modified` int(11) NOT NULL,
  `private` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `remote_id` (`remote_id`)
);

CREATE TABLE IF NOT EXISTS `bx_timeline_videos2events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL DEFAULT '0',
  `media_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `media` (`event_id`, `media_id`)
);

CREATE TABLE IF NOT EXISTS `bx_timeline_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(10) unsigned NOT NULL,
  `remote_id` varchar(128) NOT NULL,
  `path` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `mime_type` varchar(128) NOT NULL,
  `ext` varchar(32) NOT NULL,
  `size` bigint(20) NOT NULL,
  `added` int(11) NOT NULL,
  `modified` int(11) NOT NULL,
  `private` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `remote_id` (`remote_id`)
);

CREATE TABLE IF NOT EXISTS `bx_timeline_files2events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL DEFAULT '0',
  `media_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `media` (`event_id`, `media_id`)
);

-- TABLES: LINKS
CREATE TABLE IF NOT EXISTS `bx_timeline_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(10) unsigned NOT NULL,
  `media_id` int(11) NOT NULL DEFAULT '0',
  `url` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `text` text NOT NULL,
  `added` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_id` (`profile_id`)
);

CREATE TABLE IF NOT EXISTS `bx_timeline_links2events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL DEFAULT '0',
  `link_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `link` (`link_id`, `event_id`)
);

-- TABLES: REPOSTS
CREATE TABLE IF NOT EXISTS `bx_timeline_reposts_track` (
  `event_id` int(11) NOT NULL default '0',
  `author_id` int(11) NOT NULL default '0',
  `author_nip` int(11) unsigned NOT NULL default '0',
  `reposted_id` int(11) NOT NULL default '0',
  `date` int(11) NOT NULL default '0',
  UNIQUE KEY `event_id` (`event_id`),
  KEY `repost` (`reposted_id`, `author_nip`)
);

-- TABLES: COMMENTS
CREATE TABLE IF NOT EXISTS `bx_timeline_comments` (
  `cmt_id` int(11) NOT NULL AUTO_INCREMENT,
  `cmt_parent_id` int(11) NOT NULL DEFAULT '0',
  `cmt_vparent_id` int(11) NOT NULL DEFAULT '0',
  `cmt_object_id` int(11) NOT NULL DEFAULT '0',
  `cmt_author_id` int(11) NOT NULL DEFAULT '0',
  `cmt_level` int(11) NOT NULL DEFAULT '0',
  `cmt_text` text NOT NULL,
  `cmt_time` int(11) unsigned NOT NULL DEFAULT '0',
  `cmt_replies` int(11) NOT NULL DEFAULT '0',
  `cmt_pinned` int(11) NOT NULL default '0',
  `cmt_cf` int(11) NOT NULL default '1',
  PRIMARY KEY (`cmt_id`),
  KEY `cmt_object_id` (`cmt_object_id`,`cmt_parent_id`),
  FULLTEXT KEY `search_fields` (`cmt_text`)
);

-- TABLE: views
CREATE TABLE IF NOT EXISTS `bx_timeline_views_track` (
  `object_id` int(11) NOT NULL default '0',
  `viewer_id` int(11) NOT NULL default '0',
  `viewer_nip` int(11) unsigned NOT NULL default '0',
  `date` int(11) NOT NULL default '0',
  KEY `id` (`object_id`,`viewer_id`,`viewer_nip`)
);

-- TABLES: VOTES
CREATE TABLE IF NOT EXISTS `bx_timeline_votes` (
  `object_id` int(11) NOT NULL default '0',
  `count` int(11) NOT NULL default '0',
  `sum` int(11) NOT NULL default '0',
  UNIQUE KEY `object_id` (`object_id`)
);

CREATE TABLE IF NOT EXISTS `bx_timeline_votes_track` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_id` int(11) NOT NULL default '0',
  `author_id` int(11) NOT NULL default '0',
  `author_nip` int(11) unsigned NOT NULL default '0',
  `value` tinyint(4) NOT NULL default '0',
  `date` int(11) NOT NULL default '0',
  PRIMARY KEY (`id`),
  KEY `vote` (`object_id`, `author_nip`)
);

CREATE TABLE IF NOT EXISTS `bx_timeline_reactions` (
  `object_id` int(11) NOT NULL default '0',
  `reaction` varchar(32) NOT NULL default '',
  `count` int(11) NOT NULL default '0',
  `sum` int(11) NOT NULL default '0',
  UNIQUE KEY `reaction` (`object_id`, `reaction`)
);

CREATE TABLE IF NOT EXISTS `bx_timeline_reactions_track` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_id` int(11) NOT NULL default '0',
  `author_id` int(11) NOT NULL default '0',
  `author_nip` int(11) unsigned NOT NULL default '0',
  `reaction` varchar(32) NOT NULL default '',
  `value` tinyint(4) NOT NULL default '0',
  `date` int(11) NOT NULL default '0',
  PRIMARY KEY (`id`),
  KEY `vote` (`object_id`, `author_nip`)
);

-- TABLE: metas
CREATE TABLE IF NOT EXISTS `bx_timeline_meta_keywords` (
  `object_id` int(10) unsigned NOT NULL,
  `keyword` varchar(255) NOT NULL,
  KEY `object_id` (`object_id`),
  KEY `keyword` (`keyword`)
);

CREATE TABLE IF NOT EXISTS `bx_timeline_meta_locations` (
  `object_id` int(10) unsigned NOT NULL,
  `lat` double NOT NULL,
  `lng` double NOT NULL,
  `country` varchar(2) NOT NULL,
  `state` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `zip` varchar(255) NOT NULL,
  `street` varchar(255) NOT NULL,
  `street_number` varchar(255) NOT NULL,
  PRIMARY KEY (`object_id`),
  KEY `country_state_city` (`country`,`state`(8),`city`(8))
);

CREATE TABLE IF NOT EXISTS `bx_timeline_meta_mentions` (
  `object_id` int(10) unsigned NOT NULL,
  `profile_id` int(10) unsigned NOT NULL,
  KEY `object_id` (`object_id`),
  KEY `profile_id` (`profile_id`)
);

-- TABLE: reports
CREATE TABLE IF NOT EXISTS `bx_timeline_reports` (
  `object_id` int(11) NOT NULL default '0',
  `count` int(11) NOT NULL default '0',
  UNIQUE KEY `object_id` (`object_id`)
);

CREATE TABLE IF NOT EXISTS `bx_timeline_reports_track` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_id` int(11) NOT NULL default '0',
  `author_id` int(11) NOT NULL default '0',
  `author_nip` int(11) unsigned NOT NULL default '0',
  `type` varchar(32) NOT NULL default '',
  `text` text NOT NULL default '',
  `date` int(11) NOT NULL default '0',
  `checked_by` int(11) NOT NULL default '0',
  `status` tinyint(11) NOT NULL default '0',
  PRIMARY KEY (`id`),
  KEY `report` (`object_id`, `author_nip`)
);

-- TABLE: hot track
CREATE TABLE IF NOT EXISTS `bx_timeline_hot_track` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL default '0',
  `value` int(11) NOT NULL default '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `event_id` (`event_id`)
);

-- TABLE: scores
CREATE TABLE IF NOT EXISTS `bx_timeline_scores` (
  `object_id` int(11) NOT NULL default '0',
  `count_up` int(11) NOT NULL default '0',
  `count_down` int(11) NOT NULL default '0',
  UNIQUE KEY `object_id` (`object_id`)
);

CREATE TABLE IF NOT EXISTS `bx_timeline_scores_track` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_id` int(11) NOT NULL default '0',
  `author_id` int(11) NOT NULL default '0',
  `author_nip` int(11) unsigned NOT NULL default '0',
  `type` varchar(8) NOT NULL default '',
  `date` int(11) NOT NULL default '0',
  PRIMARY KEY (`id`),
  KEY `vote` (`object_id`, `author_nip`)
);


-- STORAGES, TRANSCODERS, UPLOADERS
SET @sStorageEngine = (SELECT `value` FROM `sys_options` WHERE `name` = 'sys_storage_default');

INSERT INTO `sys_objects_uploader` (`object`, `active`, `override_class_name`, `override_class_file`) VALUES
('bx_timeline_simple_photo', 1, 'BxTimelineUploaderSimpleAttach', 'modules/boonex/timeline/classes/BxTimelineUploaderSimpleAttach.php'),
('bx_timeline_simple_video', 1, 'BxTimelineUploaderSimpleAttach', 'modules/boonex/timeline/classes/BxTimelineUploaderSimpleAttach.php'),
('bx_timeline_html5_photo', 1, 'BxTimelineUploaderHTML5Attach', 'modules/boonex/timeline/classes/BxTimelineUploaderHTML5Attach.php'),
('bx_timeline_html5_video', 1, 'BxTimelineUploaderHTML5Attach', 'modules/boonex/timeline/classes/BxTimelineUploaderHTML5Attach.php'),
('bx_timeline_record_video', 1, 'BxTimelineUploaderRecordVideoAttach', 'modules/boonex/timeline/classes/BxTimelineUploaderRecordVideoAttach.php'),
('bx_timeline_simple_file', 1, 'BxTimelineUploaderSimpleAttach', 'modules/boonex/timeline/classes/BxTimelineUploaderSimpleAttach.php'),
('bx_timeline_html5_file', 1, 'BxTimelineUploaderHTML5Attach', 'modules/boonex/timeline/classes/BxTimelineUploaderHTML5Attach.php');

INSERT INTO `sys_objects_storage` (`object`, `engine`, `params`, `token_life`, `cache_control`, `levels`, `table_files`, `ext_mode`, `ext_allow`, `ext_deny`, `quota_size`, `current_size`, `quota_number`, `current_number`, `max_file_size`, `ts`) VALUES
('bx_timeline_photos', @sStorageEngine, '', 360, 2592000, 3, 'bx_timeline_photos', 'allow-deny', 'jpg,jpeg,jpe,gif,png', '', 0, 0, 0, 0, 0, 0),
('bx_timeline_photos_processed', @sStorageEngine, '', 360, 2592000, 3, 'bx_timeline_photos_processed', 'allow-deny', 'jpg,jpeg,jpe,gif,png', '', 0, 0, 0, 0, 0, 0),

('bx_timeline_videos', @sStorageEngine, 'a:1:{s:6:"fields";a:1:{s:10:"dimensions";s:17:"getFileDimensions";}}', 360, 2592000, 3, 'bx_timeline_videos', 'allow-deny', 'avi,flv,mpg,mpeg,wmv,mp4,m4v,mov,qt,divx,xvid,3gp,3g2,webm,mkv,ogv,ogg,rm,rmvb,asf,drc', '', 0, 0, 0, 0, 0, 0),
('bx_timeline_videos_processed', @sStorageEngine, '', 360, 2592000, 3, 'bx_timeline_videos_processed', 'allow-deny', 'jpg,jpeg,jpe,gif,png,avi,flv,mpg,mpeg,wmv,mp4,m4v,mov,qt,divx,xvid,3gp,3g2,webm,mkv,ogv,ogg,rm,rmvb,asf,drc', '', 0, 0, 0, 0, 0, 0),

('bx_timeline_files', @sStorageEngine, '', 360, 2592000, 3, 'bx_timeline_files', 'deny-allow', '', 'jpg,jpeg,jpe,gif,png,action,apk,app,bat,bin,cmd,com,command,cpl,csh,exe,gadget,inf,ins,inx,ipa,isu,job,jse,ksh,lnk,msc,msi,msp,mst,osx,out,paf,pif,prg,ps1,reg,rgs,run,sct,shb,shs,u3p,vb,vbe,vbs,vbscript,workflow,ws,wsf', 0, 0, 0, 0, 0, 0);

INSERT INTO `sys_objects_transcoder` (`object`, `storage_object`, `source_type`, `source_params`, `private`, `atime_tracking`, `atime_pruning`, `ts`, `override_class_name`, `override_class_file`) VALUES
('bx_timeline_photos_preview', 'bx_timeline_photos_processed', 'Storage', 'a:1:{s:6:"object";s:18:"bx_timeline_photos";}', 'no', '1', '2592000', '0', '', ''),
('bx_timeline_photos_view', 'bx_timeline_photos_processed', 'Storage', 'a:1:{s:6:"object";s:18:"bx_timeline_photos";}', 'no', '1', '2592000', '0', '', ''),
('bx_timeline_photos_medium', 'bx_timeline_photos_processed', 'Storage', 'a:1:{s:6:"object";s:18:"bx_timeline_photos";}', 'no', '1', '2592000', '0', '', ''),
('bx_timeline_photos_big', 'bx_timeline_photos_processed', 'Storage', 'a:1:{s:6:"object";s:18:"bx_timeline_photos";}', 'no', '1', '2592000', '0', '', ''),

('bx_timeline_videos_poster', 'bx_timeline_videos_processed', 'Storage', 'a:1:{s:6:"object";s:18:"bx_timeline_videos";}', 'no', '0', '0', '0', 'BxDolTranscoderVideo', ''),
('bx_timeline_videos_mp4', 'bx_timeline_videos_processed', 'Storage', 'a:1:{s:6:"object";s:18:"bx_timeline_videos";}', 'no', '0', '0', '0', 'BxDolTranscoderVideo', ''),
('bx_timeline_videos_mp4_hd', 'bx_timeline_videos_processed', 'Storage', 'a:1:{s:6:"object";s:18:"bx_timeline_videos";}', 'no', '0', '0', '0', 'BxDolTranscoderVideo', '');

INSERT INTO `sys_transcoder_filters` (`transcoder_object`, `filter`, `filter_params`, `order`) VALUES
('bx_timeline_photos_preview', 'Resize', 'a:3:{s:1:"w";s:3:"100";s:1:"h";s:3:"100";s:13:"square_resize";s:1:"1";}', '0'),
('bx_timeline_photos_view', 'Resize', 'a:1:{s:1:"w";s:3:"300";}', '0'),
('bx_timeline_photos_medium', 'Resize', 'a:1:{s:1:"w";s:3:"600";}', '0'),
('bx_timeline_photos_big', 'Resize', 'a:2:{s:1:"w";s:4:"1200";s:1:"h";s:4:"1200";}', '0'),

('bx_timeline_videos_poster', 'Poster', 'a:2:{s:1:"h";s:3:"318";s:10:"force_type";s:3:"jpg";}', 0),
('bx_timeline_videos_mp4', 'Mp4', 'a:2:{s:1:"h";s:3:"318";s:10:"force_type";s:3:"mp4";}', 0),
('bx_timeline_videos_mp4_hd', 'Mp4', 'a:3:{s:1:"h";s:3:"720";s:13:"video_bitrate";s:4:"1536";s:10:"force_type";s:3:"mp4";}', 0);


-- Forms -> Post
INSERT INTO `sys_objects_form` (`object`, `module`, `title`, `action`, `form_attrs`, `submit_name`, `table`, `key`, `uri`, `uri_title`, `params`, `deletable`, `active`, `override_class_name`, `override_class_file`) VALUES
('bx_timeline_post', @sName, '_bx_timeline_form_post', '', '', 'tlb_do_submit', 'bx_timeline_events', 'id', '', '', '', 0, 1, 'BxTimelineFormPost', 'modules/boonex/timeline/classes/BxTimelineFormPost.php');

INSERT INTO `sys_form_displays` (`display_name`, `module`, `object`, `title`, `view_mode`) VALUES
('bx_timeline_post_add', @sName, 'bx_timeline_post', '_bx_timeline_form_post_display_add', 0),
('bx_timeline_post_add_public', @sName, 'bx_timeline_post', '_bx_timeline_form_post_display_add_public', 0),
('bx_timeline_post_add_profile', @sName, 'bx_timeline_post', '_bx_timeline_form_post_display_add_profile', 0),

('bx_timeline_post_edit', @sName, 'bx_timeline_post', '_bx_timeline_form_post_display_edit', 0),

('bx_timeline_post_view', @sName, 'bx_timeline_post', '_bx_timeline_form_post_display_view', 1);

INSERT INTO `sys_form_inputs` (`object`, `module`, `name`, `value`, `values`, `checked`, `type`, `caption_system`, `caption`, `info`, `required`, `collapsed`, `html`, `attrs`, `attrs_tr`, `attrs_wrapper`, `checker_func`, `checker_params`, `checker_error`, `db_pass`, `db_params`, `editable`, `deletable`) VALUES
('bx_timeline_post', @sName, 'type', 'post', '', 0, 'hidden', '_bx_timeline_form_post_input_sys_type', '', '', 0, 0, 0, '', '', '', '', '', '', 'Xss', '', 0, 0),
('bx_timeline_post', @sName, 'action', '', '', 0, 'hidden', '_bx_timeline_form_post_input_sys_action', '', '', 0, 0, 0, '', '', '', '', '', '', 'Xss', '', 0, 0),
('bx_timeline_post', @sName, 'owner_id', '0', '', 0, 'hidden', '_bx_timeline_form_post_input_sys_owner_id', '', '', 0, 0, 0, '', '', '', '', '', '', 'Int', '', 1, 0),
('bx_timeline_post', @sName, 'text', '', '', 0, 'textarea', '_bx_timeline_form_post_input_sys_text', '_bx_timeline_form_post_input_text', '', 0, 0, 3, 'a:1:{s:12:"autocomplete";s:3:"off";}', '', '', '', '', '', 'XssHtml', '', 1, 0),
('bx_timeline_post', @sName, 'anonymous', '', '', 0, 'switcher', '_sys_form_input_sys_anonymous', '_sys_form_input_anonymous', '', 0, 0, 0, '', '', '', '', '', '', '', '', 1, 0),
('bx_timeline_post', @sName, 'date', '', '', 0, 'datetime', '_bx_timeline_form_post_input_sys_date', '_bx_timeline_form_post_input_date', '', 0, 0, 0, '', '', '', '', '', '', 'DateTimeUtc', '', 1, 0),
('bx_timeline_post', @sName, 'published', '', '', 0, 'datetime', '_bx_timeline_form_post_input_sys_date_published', '_bx_timeline_form_post_input_date_published', '_bx_timeline_form_post_input_date_published_info', 0, 0, 0, '', '', '', '', '', '', 'DateTimeUtc', '', 1, 0),
('bx_timeline_post', @sName, 'object_cf', '', '#!sys_content_filter', 0, 'select', '_sys_form_entry_input_sys_cf', '_sys_form_entry_input_cf', '', 0, 0, 0, '', '', '', '', '', '', 'Int', '', 1, 0),
('bx_timeline_post', @sName, 'object_privacy_view', '', '', 0, 'custom', '_bx_timeline_form_post_input_sys_object_privacy_view', '_bx_timeline_form_post_input_object_privacy_view', '', 1, 0, 0, '', '', '', '', '', '', '', '', 0, 0),
('bx_timeline_post', @sName, 'location', '', '', 0, 'location', '_sys_form_input_sys_location', '', '', 0, 0, 0, '', '', '', '', '', '', '', '', 1, 0),
('bx_timeline_post', @sName, 'link', '', '', 0, 'custom', '_bx_timeline_form_post_input_sys_link', '', '', 0, 0, 0, '', '', '', '', '', '', '', '', 1, 0),
('bx_timeline_post', @sName, 'photo', 'a:1:{i:0;s:23:"bx_timeline_html5_photo";}', 'a:2:{s:24:"bx_timeline_simple_photo";s:26:"_sys_uploader_simple_title";s:23:"bx_timeline_html5_photo";s:25:"_sys_uploader_html5_title";}', 0, 'files', '_bx_timeline_form_post_input_sys_photo', '_bx_timeline_form_post_input_photo', '', 0, 0, 0, '', '', '', '', '', '', '', '', 1, 0),
('bx_timeline_post', @sName, 'video', 'a:2:{i:0;s:23:"bx_timeline_html5_video";i:1;s:24:"bx_timeline_record_video";}', 'a:3:{s:24:"bx_timeline_simple_video";s:26:"_sys_uploader_simple_title";s:23:"bx_timeline_html5_video";s:25:"_sys_uploader_html5_title";s:24:"bx_timeline_record_video";s:32:"_sys_uploader_record_video_title";}', 0, 'files', '_bx_timeline_form_post_input_sys_video', '_bx_timeline_form_post_input_video', '', 0, 0, 0, '', '', '', '', '', '', '', '', 1, 0),
('bx_timeline_post', @sName, 'file', 'a:1:{i:0;s:22:"bx_timeline_html5_file";}', 'a:2:{s:23:"bx_timeline_simple_file";s:26:"_sys_uploader_simple_title";s:22:"bx_timeline_html5_file";s:25:"_sys_uploader_html5_title";}', 0, 'files', '_bx_timeline_form_post_input_sys_files', '_bx_timeline_form_post_input_files', '', 0, 0, 0, '', '', '', '', '', '', '', '', 1, 0),
('bx_timeline_post', @sName, 'attachments', '', '', 0, 'custom', '_bx_timeline_form_post_input_sys_attachments', '', '', 0, 0, 0, '', '', '', '', '', '', '', '', 1, 0),
('bx_timeline_post', @sName, 'controls', '', 'tlb_do_submit,tlb_do_cancel', 0, 'input_set', '', '', '', 0, 0, 0, '', '', '', '', '', '', '', '', 0, 0),
('bx_timeline_post', @sName, 'tlb_do_submit', '_bx_timeline_form_post_input_do_submit', '', 0, 'submit', '_bx_timeline_form_post_input_sys_do_submit', '', '', 0, 0, 0, '', '', '', '', '', '', '', '', 0, 0),
('bx_timeline_post', @sName, 'tlb_do_cancel', '_bx_timeline_form_post_input_do_cancel', '', 0, 'button', '_bx_timeline_form_post_input_sys_do_cancel', '', '', 0, 0, 0, 'a:2:{s:7:"onclick";s:51:"{js_object_view}.editPostCancel(this, {content_id})";s:5:"class";s:22:"bx-def-margin-sec-left";}', '', '', '', '', '', '', '', 0, 0);

INSERT INTO `sys_form_display_inputs` (`display_name`, `input_name`, `visible_for_levels`, `active`, `order`) VALUES
('bx_timeline_post_add', 'type', 2147483647, 1, 0),
('bx_timeline_post_add', 'action', 2147483647, 1, 1),
('bx_timeline_post_add', 'text', 2147483647, 1, 2),
('bx_timeline_post_add', 'attachments', 2147483647, 1, 3),
('bx_timeline_post_add', 'owner_id', 2147483647, 1, 4),
('bx_timeline_post_add', 'object_privacy_view', 2147483647, 1, 5),
('bx_timeline_post_add', 'object_cf', 2147483647, 1, 6),
('bx_timeline_post_add', 'published', 192, 1, 7),
('bx_timeline_post_add', 'location', 2147483647, 1, 8),
('bx_timeline_post_add', 'link', 2147483647, 1, 9),
('bx_timeline_post_add', 'photo', 2147483647, 1, 10),
('bx_timeline_post_add', 'video', 2147483647, 1, 11),
('bx_timeline_post_add', 'file', 2147483647, 1, 12),
('bx_timeline_post_add', 'tlb_do_submit', 2147483647, 1, 13),

('bx_timeline_post_add_public', 'type', 2147483647, 1, 0),
('bx_timeline_post_add_public', 'action', 2147483647, 1, 1),
('bx_timeline_post_add_public', 'owner_id', 2147483647, 1, 2),
('bx_timeline_post_add_public', 'text', 2147483647, 1, 3),
('bx_timeline_post_add_public', 'attachments', 2147483647, 1, 4),
('bx_timeline_post_add_public', 'object_privacy_view', 2147483647, 1, 5),
('bx_timeline_post_add_public', 'object_cf', 2147483647, 1, 6),
('bx_timeline_post_add_public', 'published', 192, 1, 7),
('bx_timeline_post_add_public', 'location', 2147483647, 1, 8),
('bx_timeline_post_add_public', 'link', 2147483647, 1, 9),
('bx_timeline_post_add_public', 'photo', 2147483647, 1, 10),
('bx_timeline_post_add_public', 'video', 2147483647, 1, 11),
('bx_timeline_post_add_public', 'file', 2147483647, 1, 12),
('bx_timeline_post_add_public', 'tlb_do_submit', 2147483647, 1, 13),

('bx_timeline_post_add_profile', 'type', 2147483647, 1, 0),
('bx_timeline_post_add_profile', 'action', 2147483647, 1, 1),
('bx_timeline_post_add_profile', 'owner_id', 2147483647, 1, 2),
('bx_timeline_post_add_profile', 'text', 2147483647, 1, 3),
('bx_timeline_post_add_profile', 'attachments', 2147483647, 1, 4),
('bx_timeline_post_add_profile', 'object_privacy_view', 2147483647, 1, 5),
('bx_timeline_post_add_profile', 'object_cf', 2147483647, 1, 6),
('bx_timeline_post_add_profile', 'published', 192, 1, 7),
('bx_timeline_post_add_profile', 'location', 2147483647, 1, 8),
('bx_timeline_post_add_profile', 'link', 2147483647, 1, 9),
('bx_timeline_post_add_profile', 'photo', 2147483647, 1, 10),
('bx_timeline_post_add_profile', 'video', 2147483647, 1, 11),
('bx_timeline_post_add_profile', 'file', 2147483647, 1, 12),
('bx_timeline_post_add_profile', 'tlb_do_submit', 2147483647, 1, 13),

('bx_timeline_post_edit', 'type', 2147483647, 1, 1),
('bx_timeline_post_edit', 'action', 2147483647, 1, 2),
('bx_timeline_post_edit', 'owner_id', 2147483647, 1, 3),
('bx_timeline_post_edit', 'text', 2147483647, 1, 4),
('bx_timeline_post_edit', 'attachments', 2147483647, 1, 5),
('bx_timeline_post_edit', 'published', 192, 1, 6),
('bx_timeline_post_edit', 'location', 2147483647, 1, 7),
('bx_timeline_post_edit', 'link', 2147483647, 1, 8),
('bx_timeline_post_edit', 'photo', 2147483647, 1, 9),
('bx_timeline_post_edit', 'video', 2147483647, 1, 10),
('bx_timeline_post_edit', 'file', 2147483647, 1, 11),
('bx_timeline_post_edit', 'object_cf', 2147483647, 1, 12),
('bx_timeline_post_edit', 'controls', 2147483647, 1, 13),
('bx_timeline_post_edit', 'tlb_do_submit', 2147483647, 1, 14),
('bx_timeline_post_edit', 'tlb_do_cancel', 2147483647, 1, 15);

-- Forms -> Attach link
INSERT INTO `sys_objects_form` (`object`, `module`, `title`, `action`, `form_attrs`, `submit_name`, `table`, `key`, `uri`, `uri_title`, `params`, `deletable`, `active`, `override_class_name`, `override_class_file`) VALUES
('bx_timeline_attach_link', @sName, '_bx_timeline_form_attach_link', '', '', 'do_submit', 'bx_timeline_links', 'id', '', '', '', 0, 1, '', '');

INSERT INTO `sys_form_displays` (`display_name`, `module`, `object`, `title`, `view_mode`) VALUES
('bx_timeline_attach_link_add', @sName, 'bx_timeline_attach_link', '_bx_timeline_form_attach_link_display_add', 0);

INSERT INTO `sys_form_inputs` (`object`, `module`, `name`, `value`, `values`, `checked`, `type`, `caption_system`, `caption`, `info`, `required`, `collapsed`, `html`, `attrs`, `attrs_tr`, `attrs_wrapper`, `checker_func`, `checker_params`, `checker_error`, `db_pass`, `db_params`, `editable`, `deletable`) VALUES
('bx_timeline_attach_link', @sName, 'event_id', '0', '', 0, 'hidden', '_bx_timeline_form_attach_link_input_sys_event_id', '', '', 0, 0, 0, '', '', '', '', '', '', '', '', 0, 0),
('bx_timeline_attach_link', @sName, 'url', '', '', 0, 'text', '_bx_timeline_form_attach_link_input_sys_url', '_bx_timeline_form_attach_link_input_url', '', 0, 0, 0, '', '', '', 'Preg', 'a:1:{s:4:"preg";s:0:"";}', '_bx_timeline_form_attach_link_input_url_err', '', '', 0, 0),
('bx_timeline_attach_link', @sName, 'controls', '', 'do_submit,do_cancel', 0, 'input_set', '', '', '', 0, 0, 0, '', '', '', '', '', '', '', '', 0, 0),
('bx_timeline_attach_link', @sName, 'do_submit', '_bx_timeline_form_attach_link_input_do_submit', '', 0, 'submit', '_bx_timeline_form_attach_link_input_sys_do_submit', '', '', 0, 0, 0, '', '', '', '', '', '', '', '', 0, 0),
('bx_timeline_attach_link', @sName, 'do_cancel', '_bx_timeline_form_attach_link_input_do_cancel', '', 0, 'button', '_bx_timeline_form_attach_link_input_do_cancel', '', '', 0, 0, 0, 'a:2:{s:7:"onclick";s:45:"$(''.bx-popup-applied:visible'').dolPopupHide()";s:5:"class";s:22:"bx-def-margin-sec-left";}', '', '', '', '', '', '', '', 0, 0);

INSERT INTO `sys_form_display_inputs` (`display_name`, `input_name`, `visible_for_levels`, `active`, `order`) VALUES
('bx_timeline_attach_link_add', 'event_id', 2147483647, 1, 1),
('bx_timeline_attach_link_add', 'url', 2147483647, 1, 2),
('bx_timeline_attach_link_add', 'controls', 2147483647, 1, 3),
('bx_timeline_attach_link_add', 'do_submit', 2147483647, 1, 4),
('bx_timeline_attach_link_add', 'do_cancel', 2147483647, 1, 5);

-- Forms -> Repost To
INSERT INTO `sys_objects_form` (`object`, `module`, `title`, `action`, `form_attrs`, `submit_name`, `table`, `key`, `uri`, `uri_title`, `params`, `deletable`, `active`, `override_class_name`, `override_class_file`) VALUES
('bx_timeline_repost', @sName, '_bx_timeline_form_repost', '', '', 'do_submit', '', '', '', '', '', 0, 1, 'BxTimelineFormRepost', 'modules/boonex/timeline/classes/BxTimelineFormRepost.php');

INSERT INTO `sys_form_displays` (`display_name`, `module`, `object`, `title`, `view_mode`) VALUES
('bx_timeline_repost_with', @sName, 'bx_timeline_repost', '_bx_timeline_form_repost_display_with', 0),
('bx_timeline_repost_to', @sName, 'bx_timeline_repost', '_bx_timeline_form_repost_display_to', 0);

INSERT INTO `sys_form_inputs` (`object`, `module`, `name`, `value`, `values`, `checked`, `type`, `caption_system`, `caption`, `info`, `required`, `collapsed`, `html`, `attrs`, `attrs_tr`, `attrs_wrapper`, `checker_func`, `checker_params`, `checker_error`, `db_pass`, `db_params`, `editable`, `deletable`) VALUES
('bx_timeline_repost', @sName, 'reposter_id', '', '', 0, 'hidden', '_bx_timeline_form_repost_input_sys_reposter_id', '', '', 0, 0, 0, '', '', '', '', '', '', 'Int', '', 0, 0),
('bx_timeline_repost', @sName, 'owner_id', '', '', 0, 'hidden', '_bx_timeline_form_repost_input_sys_owner_id', '', '', 0, 0, 0, '', '', '', '', '', '', 'Int', '', 0, 0),
('bx_timeline_repost', @sName, 'type', '', '', 0, 'hidden', '_bx_timeline_form_repost_input_sys_type', '', '', 0, 0, 0, '', '', '', '', '', '', 'Xss', '', 0, 0),
('bx_timeline_repost', @sName, 'action', '', '', 0, 'hidden', '_bx_timeline_form_repost_input_sys_action', '', '', 0, 0, 0, '', '', '', '', '', '', 'Xss', '', 0, 0),
('bx_timeline_repost', @sName, 'object_id', '', '', 0, 'hidden', '_bx_timeline_form_repost_input_sys_object_id', '', '', 0, 0, 0, '', '', '', '', '', '', 'Int', '', 0, 0),
('bx_timeline_repost', @sName, 'search', '', '', 0, 'custom', '_bx_timeline_form_repost_input_sys_search', '_bx_timeline_form_repost_input_search', '', 0, 0, 0, '', '', '', '', '', '', '', '', 0, 0),
('bx_timeline_repost', @sName, 'list', '', '', 0, 'custom', '_bx_timeline_form_repost_input_sys_list', '_bx_timeline_form_repost_input_list', '', 0, 0, 0, '', '', '', '', '', '', '', '', 0, 0),
('bx_timeline_repost', @sName, 'text', '', '', 0, 'textarea', '_bx_timeline_form_repost_input_sys_text', '_bx_timeline_form_repost_input_text', '', 0, 0, 0, 'a:1:{s:12:"autocomplete";s:3:"off";}', '', '', '', '', '', 'XssHtml', '', 1, 0),
('bx_timeline_repost', @sName, 'reposted', '', '', 0, 'custom', '_bx_timeline_form_repost_input_sys_reposted', '_bx_timeline_form_repost_input_reposted', '', 0, 0, 0, '', '', '', '', '', '', '', '', 0, 0),
('bx_timeline_repost', @sName, 'controls', '', 'do_submit,do_cancel', 0, 'input_set', '', '', '', 0, 0, 0, '', '', '', '', '', '', '', '', 0, 0),
('bx_timeline_repost', @sName, 'do_submit', '_bx_timeline_form_repost_input_do_submit', '', 0, 'submit', '_bx_timeline_form_repost_input_sys_do_submit', '', '', 0, 0, 0, '', '', '', '', '', '', '', '', 0, 0),
('bx_timeline_repost', @sName, 'do_cancel', '_bx_timeline_form_repost_input_do_cancel', '', 0, 'button', '_bx_timeline_form_repost_input_sys_do_cancel', '', '', 0, 0, 0, 'a:2:{s:7:"onclick";s:45:"$(''.bx-popup-applied:visible'').dolPopupHide()";s:5:"class";s:22:"bx-def-margin-sec-left";}', '', '', '', '', '', '', '', 0, 0);

INSERT INTO `sys_form_display_inputs` (`display_name`, `input_name`, `visible_for_levels`, `active`, `order`) VALUES
('bx_timeline_repost_with', 'reposter_id', 2147483647, 1, 1),
('bx_timeline_repost_with', 'owner_id', 2147483647, 1, 2),
('bx_timeline_repost_with', 'type', 2147483647, 1, 3),
('bx_timeline_repost_with', 'action', 2147483647, 1, 4),
('bx_timeline_repost_with', 'object_id', 2147483647, 1, 5),
('bx_timeline_repost_with', 'text', 2147483647, 1, 6),
('bx_timeline_repost_with', 'reposted', 2147483647, 1, 7),
('bx_timeline_repost_with', 'controls', 2147483647, 1, 8),
('bx_timeline_repost_with', 'do_submit', 2147483647, 1, 9),
('bx_timeline_repost_with', 'do_cancel', 2147483647, 1, 10),

('bx_timeline_repost_to', 'reposter_id', 2147483647, 1, 1),
('bx_timeline_repost_to', 'type', 2147483647, 1, 2),
('bx_timeline_repost_to', 'action', 2147483647, 1, 3),
('bx_timeline_repost_to', 'object_id', 2147483647, 1, 4),
('bx_timeline_repost_to', 'search', 2147483647, 1, 5),
('bx_timeline_repost_to', 'list', 2147483647, 1, 6),
('bx_timeline_repost_to', 'controls', 2147483647, 1, 7),
('bx_timeline_repost_to', 'do_submit', 2147483647, 1, 8),
('bx_timeline_repost_to', 'do_cancel', 2147483647, 1, 9);


-- COMMENTS
INSERT INTO `sys_objects_cmts` (`Name`, `Module`, `Table`, `CharsPostMin`, `CharsPostMax`, `CharsDisplayMax`, `Html`, `PerView`, `PerViewReplies`, `BrowseType`, `IsBrowseSwitch`, `PostFormPosition`, `NumberOfLevels`, `IsDisplaySwitch`, `IsRatable`, `ViewingThreshold`, `IsOn`, `RootStylePrefix`, `BaseUrl`, `ObjectVote`, `TriggerTable`, `TriggerFieldId`, `TriggerFieldAuthor`, `TriggerFieldTitle`, `TriggerFieldComments`, `ClassName`, `ClassFile`) VALUES
('bx_timeline', 'bx_timeline', 'bx_timeline_comments', 1, 5000, 1000, 3, 5, 3, 'tail', 1, 'bottom', 1, 1, 1, -3, 1, 'cmt', 'page.php?i=item&id={object_id}', '', 'bx_timeline_events', 'id', 'object_id', 'title', 'comments', '', '');


-- VIEWS
INSERT INTO `sys_objects_view` (`name`, `table_track`, `period`, `is_on`, `trigger_table`, `trigger_field_id`, `trigger_field_author`, `trigger_field_count`, `class_name`, `class_file`) VALUES 
('bx_timeline', 'bx_timeline_views_track', '86400', '1', 'bx_timeline_events', 'id', 'object_id', 'views', '', '');


-- VOTES
INSERT INTO `sys_objects_vote`(`Name`, `TableMain`, `TableTrack`, `PostTimeout`, `MinValue`, `MaxValue`, `IsUndo`, `IsOn`, `TriggerTable`, `TriggerFieldId`, `TriggerFieldAuthor`, `TriggerFieldRate`, `TriggerFieldRateCount`, `ClassName`, `ClassFile`) VALUES 
('bx_timeline', 'bx_timeline_votes', 'bx_timeline_votes_track', '604800', '1', '1', '0', '1', 'bx_timeline_events', 'id', 'object_id', 'rate', 'votes', 'BxTimelineVoteLikes', 'modules/boonex/timeline/classes/BxTimelineVoteLikes.php'),
('bx_timeline_reactions', 'bx_timeline_reactions', 'bx_timeline_reactions_track', '604800', '1', '1', '1', '1', 'bx_timeline_events', 'id', 'object_id', 'rrate', 'rvotes', 'BxTemplVoteReactions', '');


-- SCORES
INSERT INTO `sys_objects_score` (`name`, `module`, `table_main`, `table_track`, `post_timeout`, `is_on`, `trigger_table`, `trigger_field_id`, `trigger_field_author`, `trigger_field_score`, `trigger_field_cup`, `trigger_field_cdown`, `class_name`, `class_file`) VALUES 
('bx_timeline', 'bx_timeline', 'bx_timeline_scores', 'bx_timeline_scores_track', '604800', '0', 'bx_timeline_events', 'id', 'object_id', 'score', 'sc_up', 'sc_down', '', '');


-- REPORTS
INSERT INTO `sys_objects_report` (`name`, `module`, `table_main`, `table_track`, `is_on`, `base_url`, `trigger_table`, `trigger_field_id`, `trigger_field_author`, `trigger_field_count`, `class_name`, `class_file`) VALUES 
('bx_timeline', 'bx_timeline', 'bx_timeline_reports', 'bx_timeline_reports_track', '1', 'page.php?i=item&id={object_id}', 'bx_timeline_events', 'id', 'owner_id', 'reports',  'BxTimelineReport', 'modules/boonex/timeline/classes/BxTimelineReport.php');


-- CONTENT INFO
INSERT INTO `sys_objects_content_info` (`name`, `title`, `alert_unit`, `alert_action_add`, `alert_action_update`, `alert_action_delete`, `class_name`, `class_file`) VALUES
('bx_timeline', '_bx_timeline', 'bx_timeline', 'post_common', '', 'delete', '', ''),
('bx_timeline_cmts', '_bx_timeline_cmts', 'bx_timeline', 'commentPost', 'commentUpdated', 'commentRemoved', 'BxDolContentInfoCmts', '');


-- STUDIO PAGE & WIDGET
INSERT INTO `sys_std_pages`(`index`, `name`, `header`, `caption`, `icon`) VALUES
(3, 'bx_timeline', '_bx_timeline', '_bx_timeline', 'bx_timeline@modules/boonex/timeline/|std-icon.svg');
SET @iPageId = LAST_INSERT_ID();

SET @iParentPageId = (SELECT `id` FROM `sys_std_pages` WHERE `name` = 'home');
SET @iParentPageOrder = (SELECT MAX(`order`) FROM `sys_std_pages_widgets` WHERE `page_id` = @iParentPageId);
INSERT INTO `sys_std_widgets` (`page_id`, `module`, `type`, `url`, `click`, `icon`, `caption`, `cnt_notices`, `cnt_actions`) VALUES
(@iPageId, 'bx_timeline', 'extensions', '{url_studio}module.php?name=bx_timeline', '', 'bx_timeline@modules/boonex/timeline/|std-icon.svg', '_bx_timeline', '', 'a:4:{s:6:"module";s:6:"system";s:6:"method";s:11:"get_actions";s:6:"params";a:0:{}s:5:"class";s:18:"TemplStudioModules";}');
INSERT INTO `sys_std_pages_widgets` (`page_id`, `widget_id`, `order`) VALUES
(@iParentPageId, LAST_INSERT_ID(), IF(ISNULL(@iParentPageOrder), 1, @iParentPageOrder + 1));

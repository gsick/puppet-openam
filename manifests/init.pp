# == Class: openam
#
# Module for deployment and configuration of ForgeRock OpenAM with tools.
#
# === Authors
#
# Eivind Mikkelsen <eivindm@conduct.no>
#
# === Copyright
#
# Copyright (c) 2013 Conduct AS
#

class openam(
  $version                = hiera('openam::version'),
  $master                 = hiera('openam::master', undef),
  $java_home              = hiera('openam::java_home'),
  $tomcat_user            = hiera('openam::tomcat_user'),
  $tomcat_home            = hiera('openam::tomcat_home'),
  $amadmin_pwd            = hiera('openam::amadmin_pwd'),
  $amldapuser_pwd         = hiera('openam::amldapuser_pwd'),
  $config_dir             = hiera('openam::config_dir'),
  $cookie_domain          = hiera('openam::cookie_domain'),
  $log_dir                = hiera('openam::log_dir'),
  $deployment_uri         = hiera('openam::deployment_uri'),
  $locale                 = hiera('openam::locale', 'en_US'),
  $encryption_key         = hiera('openam::encryption_key'),
  $server_port            = hiera('openam::server_port'),
  $site_url               = hiera('openam::site_url', undef),
  $server_protocol        = hiera('openam::server_protocol'),
  $host                   = hiera('openam::host', $fqdn),
  $ssoadm                 = hiera('openam::ssoadm', '/usr/local/bin/ssoadm'),
  $configstore_type       = hiera('openam::configstore_type', "dirServer"),
  $configstore_ssl        = hiera('openam::configstore_ssl', "SIMPLE"),
  $configstore_server     = hiera('openam::configstore_server', 'opendj::host'),
  $configstore_port       = hiera('openam::configstore_port', 'opendj::ldap_port'),
  $configstore_admin_port = hiera('openam::configstore_admin_port', 'opendj::admin_port'),
  $configstore_jmx_port   = hiera('openam::configstore_jmx_port', 'opendj::jmx_port'),
  $configstore_suffix     = hiera('openam::configstore_suffix', "o=openam"),
  $configstore_binddn     = hiera('openam::configstore_binddn', "cn=Directory Manager"),
  $configstore_bindpw     = hiera('openam::configstore_bindpw'),
  $userstore_type         = hiera('openam::userstore_type', "LDAPv3ForOpenDS"),
  $userstore_ssl          = hiera('openam::userstore_ssl', "SIMPLE"),
  $userstore_host         = hiera('openam::userstore_host', 'opendj::host'),
  $userstore_port         = hiera('openam::userstore_port', 'opendj::ldap_port'),
  $userstore_suffix       = hiera('openam::userstore_suffix', 'opendj::base_dn'),
  $userstore_binddn       = hiera('openam::userstore_binddn', 'opendj::admin_user'),
  $userstore_bindpw       = hiera('openam::userstore_bindpw', 'opendj::admin_password'),

) {

  include openam::deploy
  include openam::config
  include openam::logs
  include openam::tools

  Class['opendj'] 	     -> Class['openam::deploy']
  Class['openam::deploy']    -> Class['openam::config']
  Class['openam::config']    -> Class['openam::logs']
  Class['openam::logs']      -> Class['openam::tools']
}

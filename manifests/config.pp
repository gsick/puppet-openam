# == Class: openam::config
#
# Module for initial configuration of ForgeRock OpenAM.
#
# === Authors
#
# Eivind Mikkelsen <eivindm@conduct.no>
#
# === Copyright
#
# Copyright (c) 2013 Conduct AS
#

class openam::config {
  $server_url = "${openam::server_protocol}://${openam::host}:${openam::server_port}"
 
  package { "perl-Crypt-SSLeay": ensure => installed }
  package { "perl-libwww-perl": ensure => installed }
  
  file { "${openam::deploy_container_home}/.openamcfg":
    ensure => directory,
    owner  => "${openam::deploy_container_user}",
    group  => "${openam::deploy_container_group}",
    mode   => 755,
  }
 
  # Contains passwords, thus (temporarily) stored in ${openam::tmp}
  file { "${openam::tmp}/configurator.properties":
    owner   => root,
    group   => root,
    mode    => 600,
    content => template("${module_name}/configurator.properties.erb"),
  }

  file { "${openam::tmp}/configurator.pl":
    owner   => root,
    group   => root,
    mode    => 700,
    require => File["${openam::tmp}/configurator.properties"], 
    source  => "puppet:///modules/${module_name}/configurator.pl",
  }

  file { "${openam::config_dir}":
    ensure => directory,
    owner  => "${openam::deploy_container_user}",
    group  => "${openam::deploy_container_group}",
  }

  exec { "configure openam":
    command => "${openam::tmp}/configurator.pl -f ${openam::tmp}/configurator.properties",
    require => [
      File["${openam::tmp}/configurator.pl"],
      File["${openam::config_dir}"],
      Package["perl-Crypt-SSLeay"],
      Package["perl-libwww-perl"]
    ],
    creates => "${openam::config_dir}/bootstrap",
    notify => Service["tomcat-openam"],
  }
}

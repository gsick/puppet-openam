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

  exec { "configure openam":
    command => "${openam::tmp}/configurator.pl -f ${openam::tmp}/configurator.properties",
    require => [
      File["${openam::tmp}/configurator.pl"],
      Package["perl-Crypt-SSLeay", "perl-libwww-perl"],
    ],
    creates => "${openam::config_dir}/bootstrap",
    notify => Service["tomcat-openam"],
  }
}

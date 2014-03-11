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

  singleton_packages("perl-Crypt-SSLeay", "perl-libwww-perl")

  # Contains passwords, thus (temporarily) stored in ${openam::tmp_dir}
  file { "${openam::tmp_dir}/configurator.properties":
    owner   => root,
    group   => root,
    mode    => 600,
    content => template("${module_name}/configurator.properties.erb"),
  }

  file { "${openam::tmp_dir}/configurator.pl":
    owner   => root,
    group   => root,
    mode    => 700,
    require => File["${openam::tmp_dir}/configurator.properties"], 
    source  => "puppet:///modules/${module_name}/configurator.pl",
  }

  exec { "configure openam":
    command => "${openam::tmp_dir}/configurator.pl -f ${openam::tmp_dir}/configurator.properties",
    require => [
      File["${openam::tmp_dir}/configurator.pl", "${openam::deploy_container_home}/webapps/${openam::deployment_uri}.war"],
      Package["perl-Crypt-SSLeay", "perl-libwww-perl"],
    ],
    creates => "${openam::config_dir}/bootstrap",
  }

  exec { "remove configurator temp file":
    #cwd => "${openam::tmp_dir}",
    command => "/bin/rm -rf ${openam::tmp_dir}/configurator.pl ${openam::tmp_dir}/configurator.properties",
    require => Exec["configure openam"],
  }
}

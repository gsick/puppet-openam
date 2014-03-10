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

  # Contains passwords, thus (temporarily) stored in ${openam::tmpdir}
  file { "${openam::tmpdir}/configurator.properties":
    owner   => root,
    group   => root,
    mode    => 600,
    content => template("${module_name}/configurator.properties.erb"),
  }

  file { "${openam::tmpdir}/configurator.pl":
    owner   => root,
    group   => root,
    mode    => 700,
    require => File["${openam::tmpdir}/configurator.properties"], 
    source  => "puppet:///modules/${module_name}/configurator.pl",
  }

  exec { "configure openam":
    command => "${openam::tmpdir}/configurator.pl -f ${openam::tmpdir}/configurator.properties",
    require => [
      File["${openam::tmpdir}/configurator.pl", "${openam::deploy_container_home}/webapps/${openam::deployment_uri}.war"],
      Package["perl-Crypt-SSLeay", "perl-libwww-perl"],
    ],
    creates => "${openam::config_dir}/bootstrap",
  }

  exec { "remove configurator temp file":
    cwd => "${openam::tmpdir}",
    command => "/bin/rm -rf configurator.pl configurator.properties",
    require => Exec["configure openam"],
  }
}

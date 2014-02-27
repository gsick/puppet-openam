# == Class: openam::tools
#
# Module for deployment of ssoAdminTools.
#
# === Authors
#
# Eivind Mikkelsen <eivindm@conduct.no>
#
# === Copyright
#
# Copyright (c) 2013 Conduct AS
#
class openam::tools {

  singleton_packages("unzip")

  file { "${openam::tools_dir}":
    ensure    => directory,
    mode      => 0755,
    require   => Exec["configure openam"],
  }

  file { "${openam::tmp}/SSOAdminTools-${openam::version}.zip":
    ensure => present,
    source => "${openam::file_source_dir}/SSOAdminTools-${openam::version}.zip",
  }

  exec { "deploy ssoadm":
    cwd     => "${openam::tmp}",
    creates => "${openam::tools_dir}/setup",
    require => [ Exec["configure openam"], 
                 File["${openam::tools_dir}", "${openam::tmp}/SSOAdminTools-${openam::version}.zip"], 
                 Package['unzip']
               ],
    command => "/usr/bin/unzip SSOAdminTools-${openam::version}.zip -d ${openam::tools_dir}/",
  }

  exec { "configure ssoadm":
    cwd         => "${openam::tools_dir}",
    creates     => "${openam::tools_dir}/${openam::deployment_uri}",
    environment => "JAVA_HOME=${openam::java_home}",
    command     => "${openam::tools_dir}/setup -p ${openam::config_dir} -d ${openam::log_dir}/debug -l ${openam::log_dir}/logs",
    require     => Exec["deploy ssoadm"],
  }

  file { "${openam::tools_dir}/.pass":
    ensure  => present,
    mode    => 400,
    require => Exec["configure ssoadm"],
    content => "${openam::amadmin_pwd}\n",
  }

  file { "${openam::ssoadm}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 700,
    content => "#!/bin/bash\nexport JAVA_HOME=${openam::java_home}\ncommand=\$1\nshift;\n${openam::tools_dir}/${openam::deployment_uri}/bin/ssoadm \$command -u amadmin -f ${openam::tools_dir}/.pass \$@",
    require => File["${openam::tools_dir}/.pass"],
  }
}

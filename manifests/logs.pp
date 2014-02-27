# == Class: openam::logs
#
# Symlinks OpenAM log directories to a suitable location.
#
# === Authors
#
# Eivind Mikkelsen <eivindm@conduct.no>
#
# === Copyright
#
# Copyright (c) 2013 Conduct AS
#
class openam::logs {

  service { 'jetty':
    ensure => "stopped",
  }

  file { [ "${openam::log_dir}",
           "${openam::log_dir}/logs",
           "${openam::log_dir}/debug",
           "${openam::log_dir}/stats" ]:
    ensure  => directory,
    owner   => "${openam::deploy_container_user}",
    group   => "${openam::deploy_container_group}",
    mode    => 700,
  }

  # Symlink $OPENAM_CONFIG_HOME/$OPENAM_URI/{debug,logs,stats} to the
  # configured log directory, usually this would be /var/log/openam or
  # another directory on a partition with sufficient free disk space.

  file { "${openam::config_dir}/${openam::deployment_uri}/logs":
    ensure    => link,
    target    => "${openam::log_dir}/logs",
    require   => File["${openam::log_dir}/logs"],
    force     => true,
    notify    =>
  }

  file { "${openam::config_dir}/${openam::deployment_uri}/debug":
    ensure    => link,
    target    => "${openam::log_dir}/debug",
    require   => File["${openam::log_dir}/debug"],
    force     => true,
  }

  file { "${openam::config_dir}/${openam::deployment_uri}/stats":
    ensure    => link,
    target    => "${openam::log_dir}/stats",
    require   => File["${openam::log_dir}/stats"],
    force     => true,
  }
}


class openam::deploy::tomcat (
  $war          = hiera('openam::deploy::tomcat::war', undef),
) {

  file { "${openam::deploy_container_home}/webapps/${openam::deployment_uri}.war":
    ensure => present,
    owner  => "${openam::deploy_container_user}",
    group  => "${openam::deploy_container_group}",
    mode   => 0755,
    source => puppet:///files/${module_name}/${environment}/${openam::deploy::war},
    notify => Service['tomcat-openam'],
  }
}
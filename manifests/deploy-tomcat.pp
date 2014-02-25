
class openam::deploy::tomcat (
  $source       = hiera('openam::deploy::tomcat::source', undef),
  $war          = hiera('openam::deploy::tomcat::war', undef),
) {

  file { "${openam::deploy_container_home}/webapps${openam::deployment_uri}.war":
    ensure => present,
    owner  => "${openam::deploy_container_user}",
    group  => "${openam::deploy_container_group}",
    mode   => 0755,
    source => ${source},
    notify => Service['tomcat-openam'],
  }
}
# == Class: openam::deploy
#
# Module for deployment of ForgeRock OpenAM.
#
# === Authors
#
# Eivind Mikkelsen <eivindm@conduct.no>
#
# === Copyright
#
# Copyright (c) 2013 Conduct AS
#

class openam::deploy {
  $war = "OpenAM-${openam::version}.war"
  #$source = "puppet:///files/${module_name}/${environment}/${war}"
  $source = "/tmp/openam/${war}"

  case $openam::deploy_container_type {
    'jetty':    { class {'jetty::deploy': source => ${openam::deploy::source}, war => ${openam::deployment_uri}.war} }
    'tomcat':   { class {'openam::deploy::tomcat': war => ${war}} }
  }
}
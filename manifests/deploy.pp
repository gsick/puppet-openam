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
  $war = "openam_${openam::version}.war"
  $source = "puppet:///files/${module_name}/${environment}/${war}"

  case $deploy_container_type {
    'jetty':    { class {'jetty::deploy': source => ${source}, war => ${war}} }
    'tomcat':   { class {'openam::deploy::tomcat': source => ${source}} }
  }
}
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
    'jetty':    { Class {'jetty::deploy': $source => "puppet:///files/${module_name}/${environment}/${war}", $war => $war} }
    'tomcat':   { include openam::deploy::tomcat }
  }
}
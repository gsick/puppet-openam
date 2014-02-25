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
  $war_name = "openam_${openam::version}.war"

  case $deploy_container_type {
    'jetty':    { Class {'jetty::deploy': $source => "puppet:///files/${module_name}/${environment}/${war_name}", $war => ${war_name}} }
    'tomcat':   { Class {'openam::deploy::tomcat': $source => "puppet:///files/${module_name}/${environment}/${war_name}"}
  }
}
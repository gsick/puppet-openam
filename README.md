# Puppet Module for ForgeRock OpenAM

`puppet-openam` deploys and configures your OpenAM servers with Puppet.

## Initial configuration

The module supports initial configuration of OpenAM through a POST
to `/config/configurator` from the included `configurator.pl` script.

    class { 'openam': }

The following parameters controls the initial configuration of OpenAM:

  * `version`: The OpenAM version number
  * `java_home`: Java home
  * `deploy_container_user`: The POSIX user running the deployement container
  * `deploy_container_group`: The POSIX group running the deployement container
  * `deploy_container_home`: The home directory for the deployement container
  * `amadmin_pwd`: The OpenAM amadmin user password
  * `amldapuser_pwd`: The OpenAM amldapuser password (can't be the same as amadmin) used for agent
  * `deployment_uri`: The OpenAM deployment URI, e.g. `/sso`
  * `site_url`: The OpenAM site URL, e.g. `https://idp.example.com:443/sso`
  * `server_protocol`: The OpenAM server protocol, `http` or `https`
  * `cookie_domain`: The OpenAM cookie domain, e.g. `.example.com`
  * `config_dir`: The OpenAM configuration directory, e.g. `/opt/openam`
  * `log_dir`: The destination directory for OpenAM logs, e.g. `/var/log`
  * `locale`: The OpenAM locale, e.g. `en_US`
  * `ssoadm`: The path to install the ssoadm wrapper, default `/usr/local/bin/ssoadm`
  * `encryption_key`: The OpenAM encryption key
  * `configstore_type`: The OpenAM Data store type (`dirServer` or `embedded`), default `dirServer`
  * `configstore_ssl`: The OpenAM Data store with or without SSL (`SIMPLE` or `SSL`), default `SIMPLE`
  * `configstore_server`: The OpenAM Data store host, default `opendj::host`
  * `configstore_port`: The OpenAM Data store LDAP port, default `opendj::ldap_port`
  * `configstore_admin_port`: The OpenAM Data store admin port, default `opendj::admin_port`
  * `configstore_jmx_port`: The OpenAM Data store admin port, default `opendj::jmx_port`
  * `configstore_binddn`: The LDAP user for the OpenAM configuration store, e.g. `cn=Directory Manager`
  * `configstore_bindpw`: The password for the user specified in `configstore_binddn`
  * `configstore_suffix`: The root suffix for the OpenAM configuration store
  * `userstore_type`: The OpenAM configuration store type (e.g. `LDAPv3ForOpenDS`, `LDAPv3ForAD` ...), default `LDAPv3ForOpenDS`
  * `userstore_ssl`: The OpenAM configuration store with or without SSL (`SIMPLE` or `SSL`), default `SIMPLE`
  * `userstore_host`: The OpenAM configuration store host, default `opendj::host`
  * `userstore_port`: The OpenAM configuration store port, default `opendj::port`
  * `userstore_binddn`: The LDAP user for the OpenAM user store, e.g. `cn=Directory Manager`
  * `userstore_bindpw`: The password for the user specified in `userstore_binddn`
  * `userstore_suffix`: The root suffix for the OpenAM user store


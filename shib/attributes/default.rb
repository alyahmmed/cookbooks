#
# Cookbook Name: shib
# Attributes:: default
#

default["shib"]["entityid"] = "https://" + node[:opsworks][:instance][:ip]
default["shib"]["homeurl"] = "https://" + node[:opsworks][:instance][:ip]
default["shib"]["sp_ssl_key"] = "sp-key.pem"
default["shib"]["sp_ssl_cert"] = "sp-cert.pem"

default["shib"]["error_logo"] = "/shibboleth-sp/logo.jpg"
default["shib"]["error_css"] = "/shibboleth-sp/main.css"

default["shib"]["sso_entityid"] = "https://idp.testshib.org/idp/shibboleth"
default["shib"]["sso_metadata"] = "http://www.testshib.org/metadata/testshib-providers.xml"
default["shib"]["sso_metadata_local"] = "testshib-two-idp-metadata.xml"

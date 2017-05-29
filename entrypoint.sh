#!/bin/bash

# check if the `server.xml` file has been changed since the creation of this
# Docker image. If the file has been changed the entrypoint script will not
# perform modifications to the configuration file.

# Port 7990 is the Bitbucket port that's beeing described in the Dockerfile
if [ "$(stat --format "%Y" "${BITBUCKET_INSTALL}/conf/server.xml")" -eq "0" ]; then
  if [ -n "${X_PROXY_NAME}" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="7990"]' --type "attr" --name "proxyName" --value "${X_PROXY_NAME}" "${BITBUCKET_INSTALL}/conf/server.xml"
  fi
  if [ -n "${X_PROXY_PORT}" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="7990"]' --type "attr" --name "proxyPort" --value "${X_PROXY_PORT}" "${BITBUCKET_INSTALL}/conf/server.xml"
  fi
  if [ -n "${X_PROXY_SCHEME}" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="7990"]' --type "attr" --name "scheme" --value "${X_PROXY_SCHEME}" "${BITBUCKET_INSTALL}/conf/server.xml"
  fi
  if [ "${X_PROXY_SCHEME}" = "https" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="7990"]' --type "attr" --name "secure" --value "true" "${BITBUCKET_INSTALL}/conf/server.xml"
    xmlstarlet ed --inplace --pf --ps --update '//Connector[@port="7990"]/@redirectPort' --value "${X_PROXY_PORT}" "${BITBUCKET_INSTALL}/conf/server.xml"
  fi
  if [ -n "${X_PATH}" ]; then
    xmlstarlet ed --inplace --pf --ps --update '//Context/@path' --value "${X_PATH}" "${BITBUCKET_INSTALL}/conf/server.xml"
  fi
fi

exec "$@"

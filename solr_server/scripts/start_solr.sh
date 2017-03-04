#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

export JAVA_HOME=/usr/jdk64/jdk1.8.0_102/
export PATH:$PATH:$JAVA_HOME/bin
SOLR_USER=solr
SOLR_MEMORY=4g
SOLR_INSTALL_DIR=/apps/solr
SOLR_RANGER_HOME=/apps/solr/solr_server
SOLR_PORT=6083
SOLR_LOG4J_FILEPATH=$SOLR_RANGER_HOME/resources/log4j.properties
SOLR_AUTHENTICATION_TYPE=kerberos
SOLR_AUTHENTICATION_COOKIEDOMAIN=`hostname -d`
SOLR_AUTHENTICATION_SIMPLE_ALLOW_ANON=true
SOLR_AUTHENTICATION_KERBEROS_KEYTAB=/etc/security/keytabs/spnego.service.keytab
SOLR_AUTHENTICATION_KERBEROS_PRINCIPAL=`/bin/klist -k $SOLR_AUTHENTICATION_KERBEROS_KEYTAB | tail -1 | awk '{print $NF}';`
SOLR_AUTHENTICATION_KERBEROS_NAME_RULES=DEFAULT
SOLR_AUTHENTICATION_JAAS_CONF=/apps/solr_config/solr_jaas.conf
if [[ -e /etc/hadoop/conf/core-site.xml ]] ; then
	SOLR_AUTHENTICATION_KERBEROS_NAME_RULES=`/bin/xmllint --xpath "//property[name[text()='hadoop.security.auth_to_local']]/value/text()" /etc/hadoop/conf/core-site.xml`
	printf "%s\n" $SOLR_AUTHENTICATION_KERBEROS_NAME_RULES > /tmp/junk
fi

export SOLR_LOGS_DIR=/var/log/solr/

if [ "`whoami`" != "$SOLR_USER" ]; then
    if [ -w /etc/passwd ]; then
	echo "Running this script as $SOLR_USER..."
	su $SOLR_USER $0
    else
	echo "ERROR: You need to run this script $0 as user $SOLR_USER. You are currently running it as `whoami`"
    fi
    
    exit 1
fi

$SOLR_INSTALL_DIR/bin/solr start -p $SOLR_PORT -d $SOLR_INSTALL_DIR/server -m $SOLR_MEMORY -s $SOLR_RANGER_HOME -Djava.security.auth.login.config=$SOLR_AUTHENTICATION_JAAS_CONF -Dsolr.kerberos.name.rules="`printf "%s\n" $SOLR_AUTHENTICATION_KERBEROS_NAME_RULES`" -Dsolr.kerberos.cookie.domain=$SOLR_AUTHENTICATION_COOKIEDOMAIN  -Dsolr.kerberos.principal=$SOLR_AUTHENTICATION_KERBEROS_PRINCIPAL -Dsolr.kerberos.keytab=$SOLR_AUTHENTICATION_KERBEROS_KEYTAB -DauthenticationPlugin=org.apache.solr.security.KerberosPlugin -Dlog4j.configuration=file://$SOLR_LOG4J_FILEPATH

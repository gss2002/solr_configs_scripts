#!/bin/bash
bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

JAVA_HOME=/usr/jdk64/jdk1.8.0_102/
SOLR_CORE_HOME=/apps/solr_config/
SOLR_USER=solr
SOLR_CLOUD_HOME=/apps/solr/solr_cloud
SOLR_SERVER_HOME=/apps/solr/solr_server
SOLR_RANGER_PORT=6083
SOLR_INSTALL_FOLDER=/apps/solr
SOLR_LOG_FOLDER=/var/log/solr

KRBREALM=`/usr/bin/hostname -d | /usr/bin/tr '[:lower:]' '[:upper:]';`

/usr/bin/chown -R root:root $SOLR_INSTALL_FOLDER


/usr/bin/rpm -q libxml2
LIBXML2_TRUE=$?
if [[ "$LIBXML2_TRUE" != "0" ]] ; then
	yum install libxml2 -y
fi

if [ ! -d $SOLR_LOG_FOLDER ]; then
	/usr/bin/mkdir -p $SOLR_LOG_FOLDER
fi

/usr/bin/chown -R $SOLR_USER:$SOLR_USER $SOLR_LOG_FOLDER
/usr/bin/chmod a+x $SOLR_SERVER_HOME/scripts/*.sh
/usr/bin/chmod a+x $SOLR_CLOUD_HOME/scripts/*.sh

if [ -d "/etc/systemd/system/" ]; then
	/bin/cp $bin/source/solr-server.service /etc/systemd/system/
	/usr/bin/systemctl daemon-reload
	/usr/bin/systemctl enable solr-server
fi

if [ ! -d $SOLR_CORE_HOME ]; then
	/usr/bin/mkdir -p $SOLR_CORE_HOME
fi

/usr/bin/chown -R $SOLR_USER:$SOLR_USER $SOLR_CORE_HOME
/usr/bin/chmod -R 775 $SOLR_CORE_HOME

if [ -d $SOLR_CORE_HOME ]; then
	/bin/cp $bin/source/solr_jaas.conf $SOLR_CORE_HOME/solr_jaas.conf
	/bin/sed 's;REPLACE_DOMAIN_HERE;'$KRBREALM';g' -i  $SOLR_CORE_HOME/solr_jaas.conf 
fi


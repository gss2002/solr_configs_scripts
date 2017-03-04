#!/usr/bin/env bash

# You can override pass the following parameters to this script:
# 
JAVA_HOME=/usr/jdk64/jdk1.8.0_102/

JVM="java"

# Find location of this script

sdir="`dirname \"$0\"`"

if [ -n "$LOG4J_PROPS" ]; then
  log4j_config="file:$LOG4J_PROPS"
else
  log4j_config="file:$sdir/solr_cloud/resources/log4j.properties"
fi

# Settings for ZK ACL
SOLR_ZK_CREDS_AND_ACLS="-Djava.security.auth.login.config=/etc/zookeeper/conf/zookeeper_client_jaas.conf -DzkACLProvider=org.apache.solr.common.cloud.SaslZkACLProvider -DzkCredentialsProvider=org.apache.solr.common.cloud.DefaultZkCredentialsProvider"

if [[ -e /etc/hadoop/conf/core-site.xml ]] ; then
	enviro=`hostname -d | awk 'BEGIN {FS="."} { print $1}';`
        SOLR_ZK_SERVERS=`/bin/xmllint --xpath "//property[name[text()='ha.zookeeper.quorum']]/value/text()" /etc/hadoop/conf/core-site.xml`
        PATH=$JAVA_HOME/bin:$PATH $JVM $SOLR_ZK_CREDS_AND_ACLS $ZKCLI_JVM_FLAGS -Dlog4j.configuration=$log4j_config \
        -classpath "$sdir/server/solr-webapp/webapp/WEB-INF/lib/*:$sdir/server/lib/ext/*" org.apache.solr.cloud.ZkCLI -z $SOLR_ZK_SERVERS/solr_$enviro ${1+"$@"}
else
        PATH=$JAVA_HOME/bin:$PATH $JVM $SOLR_ZK_CREDS_AND_ACLS $ZKCLI_JVM_FLAGS -Dlog4j.configuration=$log4j_config \
        -classpath "$sdir/server/solr-webapp/webapp/WEB-INF/lib/*:$sdir/server/lib/ext/*" org.apache.solr.cloud.ZkCLI ${1+"$@"}
fi



#!/bin/bash
bin=`dirname "$0"`
bin=`cd "$bin"; pwd`
export http_proxy=""
export https_proxy=""
#check to see if the command line parms were passed
if [ $# -lt 2 ] ; then
    echo ""
    echo "Required Fields:"
    echo "Application Name for Solr  -app_name:<app_name>"
    echo "Solr Collection Name -collection_name:<collection_name>"
    echo "Schema Template Path -schema_template:<schema_template_path>"
    echo ""
    echo "example:  ./create_collection.sh -collection_name:vertex_index -schema_template:/etc/atlas/conf/solr"
    exit 1
fi
app_name=""
core_name=""
schema_template_path=""
for item in "$@"
do
  ARG1=`echo $item | cut -d: -f1`
  ARG2=`echo $item | cut -d: -f2`

  if [ "$ARG1" = "-collection_name" ] ; then
        core_name=$ARG2
  fi
  if [ "$ARG1" = "-app_name" ] ; then
        app_name=$ARG2
  fi
  if [ "$ARG1" = "-schema_template" ] ; then
        schema_template_path=$ARG2
  fi
done


/bin/klist -s
KLIST=$?
if [[ "$KLIST" != "0" ]] ; then
	echo "Please kinit first"
	exit 1
fi

enviro=`hostname -d | awk 'BEGIN {FS="."} { print $1}';`
hfqdn=`hostname -f`
echo $core_name
if [[ "$app_name" == "" ]] ; then
	SOLRDATADIR=/hadoop/solr/$core_name
	SOLRCONFDIR=/apps/solr_config/$core_name
	$bin/zkcli.sh -cmd upconfig -confdir $schema_template_path -confname $core_name
	/bin/curl --negotiate -u : -X GET -G "http://$hfqdn:6083/solr/admin/collections" --data-urlencode "action=CREATE" --data-urlencode "name=$core_name" --data-urlencode "property.dataDir=$SOLRDATADIR" --data-urlencode "instanceDir=$SOLRCONFDIR" --data-urlencode "wt=json" --data-urlencode "numShards=1" --data-urlencode "replicationFactor=1" --data-urlencode "maxShardsPerNode=1" --data-urlencode "collection.configName=$core_name"
else
	SOLRDATADIR=/hadoop/solr/$app_name/$core_name
	SOLRCONFDIR=/apps/solr_config/$core_name
	$bin/zkcli.sh -cmd upconfig -confdir $schema_template_path -confname $core_name
	/bin/curl --negotiate -u : -X GET -G "http://$hfqdn:6083/solr/admin/collections" --data-urlencode "action=CREATE" --data-urlencode "name=$core_name" --data-urlencode "property.dataDir=$SOLRDATADIR" --data-urlencode "instanceDir=$SOLRCONFDIR" --data-urlencode "wt=json" --data-urlencode "numShards=1" --data-urlencode "replicationFactor=1" --data-urlencode "maxShardsPerNode=1" --data-urlencode "collection.configName=$core_name"
fi




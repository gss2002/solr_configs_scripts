#!/bin/bash
app_name=$1
core_name=$2
schema_template_path=$3

export http_proxy=""
#check to see if the command line parms were passed
if [ $# -lt 3 ] ; then
    echo ""
    echo "Required Fields:"
    echo "Application Name for Solr  -app_name:<app_name>"
    echo "Solr Core Name -core_name:<core_name>"
    echo "Schema Template Path -schema_template:<schema_template_path>"
    echo ""
    echo "example:  ./create_core.sh -app_name:atlas -core_name:vertex_index -schema_template:/etc/atlas/conf/solr"
    exit 1
fi

for item in "$@"
do
  ARG1=`echo $item | cut -d: -f1`
  ARG2=`echo $item | cut -d: -f2`

  if [ "$ARG1" = "-app_name" ] ; then
        app_name=$ARG2
  fi
  if [ "$ARG1" = "-core_name" ] ; then
        core_name=$ARG2
  fi
  if [ "$ARG1" = "-schema_template" ] ; then
        schema_template_path=$ARG2
  fi
done


SOLRDATADIR=/hadoop/solr/$app_name/$core_name
SOLRCONFDIR=/apps/solr_config/$core_name
hfqdn=`hostname -f`
/bin/mkdir -p $SOLRDATADIR
/bin/mkdir -p $SOLRCONFDIR
/bin/cp -rp $schema_template_path $SOLRCONFDIR/conf/
/bin/curl -X GET -G "http://$hfqdn:6083/solr/admin/cores" --data-urlencode "action=CREATE" --data-urlencode "name=$core_name" --data-urlencode "dataDir=$SOLRDATADIR" --data-urlencode "instanceDir=$SOLRCONFDIR" --data-urlencode "config=solrconfig.xml" --data-urlencode "schema=schema.xml" --data-urlencode "wt=json"

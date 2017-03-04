#Scripts:

**create_collection.sh** - This is a custom script to upload a known template and to create the necessary configuration files for the named SolrCloud Collection. It is used for creating SolrCloud collections. Currently hardcoded for a Single Shard and Single Replica. It also obtains Zookeeper Configuration from core-site.xml using xmllint vs having to pass it on the command line.

**create_core.sh** - This is a custom script to create a Solr Core in a Standalone Solr installation and configure using a specific template.

**setup_solr.sh** - This is a custom script to setup SolrCloud after RPM installation it sets permissions and copies configuration files into place. This script also install libxml2 for xmllint package if it's not installed as xmllint is used by create_collection.sh and zkcli.sh.

**zkcli.sh** - This is an updated custom version of the zkcli.sh script provided from the package Solr installation it obtains Zookeeper Configuration from core-site.xml using xmllint vs having to pass it on the command line. This is updated to also support SASL/Kerberos access to Zookeeper. 

**source/solr-server.service** - This file is used by systemd to start, stop and restart 
SolrCloud/Solr 

**solr_cloud/scripts/start_solr.sh or solr_server/scripts/start_solr.sh** - This file is used to setup solr specific settings at startup. Specifically for Solr Standalone and SolrCloud to obtain the necessary Kerberos settings from /etc/hadoop/conf/core-site.xml and any Solr specific kerberos settings like jaas config. The SolrCloud version also sets the Zookeeper Quorum from /etc/hadoop/conf/core-site.xml if its available.

#Configuration Files:

**source/security.json** - This configuration file contains the necessary security configuration to use Kerberos for Authentication and Ranger for Authorization.

**source/solr_jaas.conf** - This configuration file contains the necessary Jaas security configuration for Solr to access Zookeeper for SolrCloud Configuration Information and HDFS for files if it is being used.

**solr_server/solr.xml** - This file contains the configuration to redirect the coreDirectory for Solr Standalone to a specified location such as /apps/solr_config

**solr_cloud/solr.xml** - This file contains the configuration to redirect the coreDirectory for SolrCloud collections to a specified location such as /apps/solr_config. It also specifies the necessary security settings such as SASL/Kerberos to access Zookeeper zNodes.

**solr_cloud/log4j.properties or solr_server/log4j.properties** - This file sets the Solr logging levels and sets the Solr log folder to /var/log/solr

**ranger_template_conf** - This folder contains the template needed to enable Ranger Audits in Solr Standalone or SolrCloud.
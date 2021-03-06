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

JAVA_HOME=/usr/jdk64/jdk1.8.0_60/
SOLR_USER=solr
SOLR_INSTALL_DIR=/apps/solr
SOLR_PORT=6083

export SOLR_LOGS_DIR=/var/log/solr/ranger_audits

if [ "`whoami`" != "$SOLR_USER" ]; then
    if [ -w /etc/passwd ]; then
	echo "Running this script as $SOLR_USER..."
	su $SOLR_USER $0
    else
	echo "ERROR: You need to run this script $0 as user $SOLR_USER. You are currently running it as `whoami`"
    fi
    
    exit 1
fi

$SOLR_INSTALL_DIR/bin/solr stop -p $SOLR_PORT

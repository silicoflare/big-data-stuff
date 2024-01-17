#!/usr/bin/env bash

echo "Patching started..."
/usr/local/hadoop/sbin/stop-all.sh
sudo apt update -y
sudo apt upgrade -y

sudo apt remove --purge openjdk* default-jdk*

sudo apt install -y openjdk-8-jdk

sudo apt install -y junit

echo "<?xml version=\"1.0\"?>
<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>
<configuration>
    <property>
      <name>mapreduce.framework.name</name>
      <value>yarn</value>
   </property>

    <property>
        <name>yarn.app.mapreduce.am.env</name>
    <value>HADOOP_MAPRED_HOME=\$HADOOP_HOME</value>
    </property>
    <property>
        <name>mapreduce.map.env</name>
        <value>HADOOP_MAPRED_HOME=\$HADOOP_HOME</value>
    </property>

    <property>
        <name>mapreduce.reduce.env</name>
        <value>HADOOP_MAPRED_HOME=\$HADOOP_HOME</value>
    </property>
</configuration>" > /usr/local/hadoop/etc/hadoop/mapred-site.xml

/usr/local/hadoop/sbin/start-all.sh
jps

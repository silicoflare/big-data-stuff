#!/usr/bin/env bash
# Hadoop Installation Script by SilicoFlare
# Credits: https://learnubuntu.com/install-hadoop/

sudo rm -rf /usr/local/hadoop
sudo rm -rf ~/hdfs
sudo rm ~/hadoop-3.3.6.tar.gz*

# Java Installation
echo "Installing Java..."
sudo apt update -y                                  # update packages
sudo apt remove -y --purge openjdk* default-jdk*    # removing other versions of java
sudo apt install -y openjdk-8-jdk                   # installing jdk 8
java -version                                       # check java version


# Configuring SSH
sudo apt install openssh-server openssh-client -y
ssh-keygen -N '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
sudo chmod 640 ~/.ssh/authorized_keys


# downloading hadoop
echo "Downloading Hadoop..."
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
tar -xvzf hadoop-3.3.6.tar.gz
sudo mv hadoop-3.3.6 /usr/local/hadoop
sudo mkdir /usr/local/hadoop/logs
sudo chown -R $USER:$USER /usr/local/hadoop


# config files
echo "Adding configurations"
echo "export HADOOP_HOME=/usr/local/hadoop
export HADOOP_INSTALL=\$HADOOP_HOME
export HADOOP_MAPRED_HOME=\$HADOOP_HOME
export HADOOP_COMMON_HOME=\$HADOOP_HOME
export HADOOP_HDFS_HOME=\$HADOOP_HOME
export YARN_HOME=\$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native
export PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin
export HADOOP_OPTS=\"-Djava.library.path=\$HADOOP_HOME/lib/native\"" >> ~/.bashrc

source ~/.bashrc

echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_CLASSPATH+=\" \$HADOOP_HOME/lib/*.jar\"" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh

cd /usr/local/hadoop/lib
sudo wget https://jcenter.bintray.com/javax/activation/javax.activation-api/1.2.0/javax.activation-api-1.2.0.jar

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>
<configuration>
    <property>
      <name>fs.default.name</name>
      <value>hdfs://0.0.0.0:9000</value>
      <description>The default file system URI</description>
   </property>
</configuration>" > /usr/local/hadoop/etc/hadoop/core-site.xml

sudo mkdir -p /home/hadoop/hdfs/{namenode,datanode}
sudo chown -R $USER:$USER /home/hadoop/hdfs

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>

    <property>
        <name>dfs.name.dir</name>
        <value>file:///home/hadoop/hdfs/namenode</value>
    </property>
 
    <property>
        <name>dfs.data.dir</name>
        <value>file:///home/hadoop/hdfs/datanode</value>
    </property>
</configuration>" > /usr/local/hadoop/etc/hadoop/hdfs-site.xml

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

echo "<?xml version=\"1.0\"?>
<configuration>
    <property>
      <name>yarn.nodemanager.aux-services</name>
      <value>mapreduce_shuffle</value>
   </property>
</configuration>" > /usr/local/hadoop/etc/hadoop/yarn-site.xml

hdfs namenode -format

/usr/local/hadoop/sbin/stop-all.sh
/usr/local/hadoop/sbin/start-dfs.sh
/usr/local/hadoop/sbin/start-yarn.sh
jps

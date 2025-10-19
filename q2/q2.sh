#!/bin/bash
Q2_HOME=$(pwd)

if hdfs dfs -test -d "/input"; then
	hdfs dfs -rm -r /input
	rm -rf $Q2_HOME/input
fi

if hdfs dfs -test -d "/output"; then
	hdfs dfs -rm -r /output
	rm -rf $Q2_HOME/output
fi

mkdir $Q2_HOME/input
mkdir $Q2_HOME/output
# Putting these quotes in three documents should invoke three Mappers
echo "To some the delightful freshness and humour of Northanger Abbey, its completeness, finish, and entrain, obscure the undoubted critical facts that its scale is small, and its scheme, after all, that of burlesque or parody, a kind in which the first rank is reached with difficulty." > $Q2_HOME/input/s1.txt
echo "Persuasion, relatively faint in tone, and not enthralling in interest, has devotees who exalt above all the others its exquisite delicacy and keeping." > $Q2_HOME/input/s2.txt
echo "The catastrophe of Mansfield Park is admittedly theatrical, the hero and heroine are insipid, and the author has almost wickedly destroyed all romantic interest by expressly admitting that Edmund only took Fanny because Mary shocked him, and that Fanny might very likely have taken Crawford if he had been a little more assiduous." > $Q2_HOME/input/s3.txt

hdfs dfs -mkdir /input
hdfs dfs -put $Q2_HOME/input/s1.txt $Q2_HOME/input/s2.txt $Q2_HOME/input/s3.txt /input

echo "Running custom jar that removes punctuation"
hadoop jar $Q2_HOME/q2JavaProject/target/hw5-1.0-SNAPSHOT.jar chaudry.data.WC_Runner /input /output
hdfs dfs -cat /output/part-00000 > $Q2_HOME/output/q2_removed.txt

if hdfs dfs -test -d "/output"; then
	hdfs dfs -rm -r /output
fi

echo "Running the example which does not remove punctuation"
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar wordcount /input /output
hdfs dfs -cat /output/part-r-00000 > $Q2_HOME/output/q2.txt

#!/bin/bash
Q3_HOME=/home/ubuntu/q3
if hdfs dfs -test -d "/input"; then
	hdfs dfs -rm -r /input
	rm -rf $Q3_HOME/input
fi
if hdfs dfs -test -d "/output"; then
	hdfs dfs -rm -r /output
	rm -rf $Q3_HOME/output
	rm -rf $Q3_HOME/output/wc_results
fi

mkdir $Q3_HOME/input
mkdir $Q3_HOME/output
mkdir $Q3_HOME/output/wc_results

touch $Q3_HOME/input/pride_and_prejudice.txt
wget -O $Q3_HOME/input/pride_and_prejudice.txt https://www.gutenberg.org/files/1342/1342-0.txt 

hdfs dfs -mkdir /input
hdfs dfs -put $Q3_HOME/input/pride_and_prejudice.txt /input

hadoop jar $Q3_HOME/q3JavaProject/target/hw5-1.0-SNAPSHOT.jar chaudry.data.WC_Runner /input /output

hdfs dfs -get /output/part-* $Q3_HOME/output/wc_results
cat $Q3_HOME/output/wc_results/part-00000 > $Q3_HOME/output/all_results.txt
echo "1. Number of unique terms shown by number of lines in all_results.txt" >> $Q3_HOME/output/q3.txt
wc -l $Q3_HOME/output/all_results.txt >> $Q3_HOME/output/q3.txt
sort $Q3_HOME/output/all_results.txt >> $Q3_HOME/output/sorted_results.txt
echo "2. 5th to last term with its word count" >> $Q3_HOME/output/q3.txt
tail -n 5 $Q3_HOME/output/sorted_results.txt | head -n 1 >> $Q3_HOME/output/q3.txt
echo "3. 1st term with its word count" >> $Q3_HOME/output/q3.txt
head -n 1 $Q3_HOME/output/sorted_results.txt >> $Q3_HOME/output/q3.txt

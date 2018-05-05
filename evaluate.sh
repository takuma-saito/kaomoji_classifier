#!/bin/bash -xe
NUM=${1:-0}
DIR=training_data/data_set_${NUM}
cat $DIR/cross_validation_data.txt | awk -F'$' '{print $1}' | ruby predict.rb $DIR | awk -F'\t' '{print $1}' > $DIR/predicted.txt
paste $DIR/cross_validation_data.txt $DIR/predicted.txt > $DIR/comparison.txt
cat $DIR/comparison.txt | ruby show_metrics.rb

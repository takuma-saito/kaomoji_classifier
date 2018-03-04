#!/bin/bash
COUNT=$1
seq 0 5 | while read num; do
    ruby learn_weight.rb training_data/data_set_${num}/training_data.json ${COUNT} 2>(tee -a training_data/data_set_${num}/stderr.log) |
        jq '.' > training_data/data_set_${num}/weights.json
done

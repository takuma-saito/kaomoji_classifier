#!/bin/bash
COUNT=$1
echo 0 | while read num; do
    ruby learn_weight.rb training_data/data_set_${num}/training_data.json ${COUNT} 2>(tee training_data/data_set_${num}/stderr.log) |
        jq '.' > training_data/data_set_${num}/weights.json
done

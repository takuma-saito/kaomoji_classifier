#!/bin/bash -xe
seq 0 5 |
    xargs -I{} bash -lc "ruby -e 'puts File.open(\"data/kaomoji.txt\").readlines.rotate(157 * {}).take(942 - 157).join' > training_data/data_set_{}/training_data.txt"
seq 0 5 |
    xargs -I{} bash -lc "ruby -e 'puts File.open(\"data/kaomoji.txt\").readlines.rotate(157 * ({} - 1)).take(157).join' > training_data/data_set_{}/cross_validation_data.txt"
seq 0 5 |
    xargs -I{} bash -lc "cat training_data/data_set_{}/training_data.txt | ruby extract_feature.rb | jq '.' > training_data/data_set_{}/training_data.json"

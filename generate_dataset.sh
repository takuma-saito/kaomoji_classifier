#!/bin/bash -xe
seq 0 10 |
    xargs -I{} mkdir -p training_data/data_set_{}
seq 0 10 |
    xargs -I{} bash -lc "ruby -e 'puts File.open(\"data/kaomoji.txt\").readlines.rotate(85 * {}).take(942 - 85).join' > training_data/data_set_{}/training_data.txt"
seq 0 10 |
    xargs -I{} bash -lc "ruby -e 'puts File.open(\"data/kaomoji.txt\").readlines.rotate(85 * ({} - 1)).take(85).join' > training_data/data_set_{}/cross_validation_data.txt"
seq 0 10 |
    xargs -I{} bash -lc "cat training_data/data_set_{}/training_data.txt | ruby extract_feature.rb | jq '.' > training_data/data_set_{}/training_data.json"

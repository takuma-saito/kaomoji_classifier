#!/bin/bash -xe
cat data/kaomoji.txt |
    ruby extract_feature.rb |
    jq -r '.' > data/features.json

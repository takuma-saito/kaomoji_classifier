#!/bin/bash
cat data/kaomoji.txt | awk -F'$' '{print $1}' | ruby predict.rb  | awk -F'\t' '{print $1 "$" $2}' > data/kaomoji_predicted.txt
paste data/kaomoji.txt data/kaomoji_predicted.txt | awk -F'\t' '{if ($1 == $2) {print "ok"} else {print "ng"}}' | sort | uniq -c
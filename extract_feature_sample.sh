#!/bin/bash -xe
cat data/sample.txt | ruby -rjson -lne "`cat <<EOF
d = \\$_.split(" ")
puts ({
  class_name: d[0],
  class_id: d[1].ord - "A".ord,
  feature_name: d[1..-1].join(" "),
  feature_vectors: [[*0..(d.length - 2)], d[1..-1].map(&:to_i)].transpose.to_h,
}.to_json)
EOF`" | jq -s '{items: [.[]]}'

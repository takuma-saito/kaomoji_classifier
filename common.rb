
require 'json'

def in_product(weight, feature_vector)
  (weight.keys + feature_vector.keys)
    .group_by {|k| k}
    .select {|k, v| v.count > 1}
    .map(&:first)
    .inject(0.0) do |memo, key|
    memo + weight[key] * feature_vector[key]
  end
end

def probs(weights, feature_vector)
  probs = weights.map do |weight|
    Math.exp(in_product(weight, feature_vector))
  end
  sum = probs.reduce(&:+)
  probs.map {|x| x / sum}
end
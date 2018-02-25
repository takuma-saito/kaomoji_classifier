# * scheme *
# class_size: 3
# items:
#   - 
#     class_name: "A"
#     class_id: 0
#     feature_name: "0 1 0"
#     feature_vector:
#       A: 2
#       B: 5
require 'json'

$feature_vectors = nil # => N x D
$answers = nil # => N x K
# weights => K X D

def read_vectors(filename)
  data = JSON.parse(File.read(filename))
  items = data['items']
  csize = data['class_size']
  feature_vectors = items.map {|x| x['feature_vector']}
  answers = items.map {|item| Array.new(csize, 0.0)}
  weight_feature = feature_vectors.map(&:values).flatten.uniq.map {|x| [x, 0.0]}.to_h
  weights = Array.new(csize, weight_feature.dup)
  [feature_vectors, answers, weights]
end

$feature_vectors, $answers, $weights =
                            read_vectors("data/sample.json")

def in_product(weight, feature_vector)
  (weight.keys + feature_vector.keys)
    .group_by {|k| k}
    .select {|k, v| v.count > 1}
    .map(&:first)
    .each_with_object(0.0) do |key, memo|
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

def with_diff_slope(weights, &block)
  $feature_vectors.each.with_index do |feature_vector, n|
    probs(weights, feature_vector).each.with_index do |prob, k|
      block.(feature_vector, n, prob, k)
    end
  end
end

def slope_diff(weights)
  memo = []
  with_diff_slope(weights) do |feature_vector, n, prob, k|
    memo[k] ||= {}
    feature_vector.each do |d, elem|
      memo[k][d] ||= 0.0
      memo[k][d] += (prob - $answers[n][k]) * elem
    end
  end
  memo
end

p slope_diff($weights)

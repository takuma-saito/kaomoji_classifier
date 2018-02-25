# * scheme *
# items:
#   - 
#     class_name: "A"
#     class_id: 0
#     feature_name: "0 1 0"
#     feature_vectors:
#       A: 2
#       B: 5

$learning_feature_vectors = [] # => N x D
$learning_answers = [] # => N x K
# weights => K X D

def in_product(weight, feature_vector)
  (weight.keys + feature_vecotr.keys)
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

def diff_slope(weights, k, d)
  memo = []
  $learn_feature_vectors.each.with_index do |feature_vector, n|
    probs(weights, feature_vector).each.with_index do |prob, k|
      memo[k] ||= []
      memo[k][d] += (prob - $learning_answers[n][k]) * feature_vector[d]
    end
  end
  memo
end


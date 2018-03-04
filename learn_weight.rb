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

require_relative 'common'

$feature_vectors = nil # => N x D
$answers = nil # => N x K
# weights => K X D

def read_vectors(filename)
  data = JSON.parse(File.read(filename))
  items = data['items']
  csize = data['class_size']
  feature_vectors = items.map {|x| x['feature_vector'].map {|k, v| [k.to_i, v]}.to_h}
  answers = items.map {|item|
    arr = Array.new(csize, 0.0)
    arr[item['class_id']] = 1.0
    arr
  }
  weight_feature = feature_vectors.map(&:keys).flatten.uniq.map {|x| [x.to_i, 0.0]}.to_h
  weights = Array.new(csize).map {weight_feature.dup}
  [feature_vectors, answers, weights]
end

$feature_vectors, $answers, $weights = read_vectors(ARGV[0])
num = (ARGV[1] || 500).to_i

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

def learn_weight(delta, num)
  ada_grad = Array.new($weights.size).map { Hash.new }
  num.times do
    slope = slope_diff($weights)
    grad_val = 0.0
    slope.each.with_index do |weight, k|
      weight.each do |d, value|
        grad_val += value ** 2
        ada_grad[k][d] ||= delta
        ada_grad[k][d] += grad_val
        $weights[k][d] -= (delta / Math.sqrt(ada_grad[k][d])) * value
      end
    end
    $stderr.puts grad_val
  end
end

learn_weight(($weights.size * 100) * 0.01, num)
$stderr.puts probs($weights, {0 => 2, 1 => 0, 2 => 2})
$stderr.puts slope_diff($weights)
puts $weights.to_json

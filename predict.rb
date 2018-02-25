
require_relative 'common'

def read_json(filename)
  JSON.parse(File.read(filename))
end

def to_vector(text)
  text.chars
    .map(&:ord)
    .group_by {|x| x}
    .map {|x| [x[0].to_s, x[1].count]}
    .to_h
end

def predict(weights, vector)
  probs(weights, vector)
    .map.with_index {|x, i| [i, x]}
    .sort_by {|v| v[1]}
    .reverse
end

weights = read_json 'data/kaomoji_weights.json'
ans = read_json('data/kaomoji_features.json')['answers']

text = $stdin.gets

prediction = predict(weights, to_vector(text)).map do |x|
  [x, ans[x[0].to_s]]
end
puts "#{text} ===> " + prediction.take(5).map {|x| "#{x[1]['name']}: #{x[0][1]}"}.join(',  ')


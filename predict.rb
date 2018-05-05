
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

dir = ARGV[0]
weights = read_json(dir + '/weights.json')
ans = read_json(dir + '/training_data.json')['answers']

while (text = $stdin.gets)&.chomp!
  prediction = predict(weights, to_vector(text)).map do |x|
    [x, ans[x[0].to_s]]
  end
  res = prediction.take(5)
  puts "#{text}$#{res[0][1]['name']}\t" + res.map {|x| "#{x[1]['name']}: #{x[0][1]}"}.join(',  ')
end

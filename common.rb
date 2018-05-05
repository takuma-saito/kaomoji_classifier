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

def with_predictions(dir, separator = nil, reader = $stdin, &block)
  weights = read_json(dir + '/weights.json')
  ans = read_json(dir + '/training_data.json')['answers']
  answer_category = nil
  while (face = reader.gets)&.chomp!
    face, answer_category = face.split(separator) if separator
    predictions = predict(weights, to_vector(face)).map do |x|
      ans[x[0].to_s].merge!("prob" => x[1])
    end
    block.(face, predictions, answer_category)
  end
end

require_relative 'common'
sum = 0
n = 0
dir = ARGV[0]
filename = 'cross_validation_data.txt'
# filename = 'training_data.txt'
with_predictions(dir, '$', File.open(dir + '/' + filename)) do |text, predictions, answer_category|
  prediction = predictions.select do |prediction|
    prediction['name'] == answer_category
  end&.first || next
  log_prob = -Math.log(prediction['prob'])
  if log_prob > 5
    puts "#{sprintf("%.3f", log_prob)},#{text},#{answer_category}," + predictions.take(5).map {|prediction|
      "#{prediction['name']}:#{sprintf("%.3f", prediction['prob'])}"
    }.join(",")
  end
  sum += log_prob
  n += 1
end
p sum / n

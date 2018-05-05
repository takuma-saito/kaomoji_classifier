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
  pp Math.log(prediction['prob']), text, answer_category, predictions.take(5)
  puts ''
  sum += -Math.log(prediction['prob'])
  n += 1
end
p sum / n

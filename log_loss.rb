require_relative 'common'
sum = 0
n = 0
dir = ARGV[0]
with_predictions(dir, '$', File.open(dir + '/cross_validation_data.txt')) do |text, predictions, answer_category|
  prediction = predictions.select do |prediction|
    prediction['name'] == answer_category
  end&.first || next
  sum += -Math.log(prediction['prob'])
  n += 1
end
p sum / n

require_relative 'common'

with_predictions(ARGV[0], '$') do |text, predictions, answer_category|
  ps = predictions.take(3)
  puts "#{text},#{answer_category},#{ps.first['name']}," +
       (ps.first['name'] == answer_category ? 'o,' : 'x,') +
       ps.map {|prediction|
    "#{prediction['name']}: #{sprintf("%.2f", prediction['prob'])}"
  }.join(',')
end

require_relative 'common'

with_predictions(ARGV[0]) do |text, predictions|
  ps = predictions.take(5)
  puts "#{text}$#{ps.first['name']}\t" + ps.map {|prediction| "#{prediction['name']}: #{prediction['prob']}"}.join(',  ')
end

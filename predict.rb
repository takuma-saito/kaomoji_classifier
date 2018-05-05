require_relative 'common'

with_predictions(ARGV[0]) do |text, predictions|
    res = predictions.take(5)
    puts "#{text}$#{res[0][1]['name']}\t" + res.map {|x| "#{x[1]['name']}: #{x[0][1]}"}.join(',  ')
end


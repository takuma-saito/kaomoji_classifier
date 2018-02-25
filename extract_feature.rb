require 'json'

items = []
categories = {}
unicodes = {}
while (line = $stdin.gets)&.chomp!
  n = line.split("$")
  ords = n[0].chars
           .map(&:ord)
           .map(&:to_i)
           .group_by {|x| x}
           .map {|key, value| [key, value.count]}.to_h
  len = categories.length
  categories[n[1]] = {
    count: (categories[n[1]]&.[](:count) || 0) + 1,
    len: (categories[n[1]]&.[](:len) || len)
  }
  items << {
    class_name: n[1],
    class_id: categories[n[1]][:len],
    feature_name: n[0],
    feature_vector: ords
  }
end

answers = categories.each_with_object({}) {|(key, value), memo|
  memo[value[:len]] = {
    count: value[:count],
    name: key,
    id: value[:len],
  }
}

# pp answers.select {|_, ans| ans[:count] == 1}
# pp answers.values.sort {|a, b| a[:count] <=> b[:count]}
puts({
       class_size: answers.count,
       answers: answers,
       items: items,
     }.to_json)

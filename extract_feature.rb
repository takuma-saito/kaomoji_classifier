require 'json'

items = []
categories = {}
unicodes = {}
while (line = $stdin.gets)&.chomp!
  n = line.split("$")
  ords = n[0].chars.map(&:ord).map(&:to_i)
  len = categories.length
  categories[n[1]] = {
    count: (categories[n[1]]&.[](:count) || 0) + 1,
    len: (categories[n[1]]&.[](:len) || len)
  }
  items << {
    t: n[1],
    t_id: categories[n[1]][:len],
    v: n[0],
    vector: ords
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
       answers: answers,
       items: items,
     }.to_json)

require 'json'

docs = []
freqs = {}
categories = {}
while (line = $stdin.gets)&.chomp!
  n = line.split("$")
  ords = n[0].chars.map(&:ord)
  ords.each {|ord|
    freqs[ord] ||= 0
    freqs[ord] += 1
  }
  len = categories.length
  categories[n[1]] = {
    count: (categories[n[1]]&.[](:count) || 0) + 1,
    len: (categories[n[1]]&.[](:len) || len)
  }
  docs << {
    t: n[1],
    t_id: categories[n[1]][:len],
    v: n[0],
    feature: ords.each_with_object({}) {|c, memo|
      memo[c] ||= 0
      memo[c] += 1
    }
  }
end

D = docs.length.to_f
idf = freqs.map {|ord, count|
  [ord, Math.log(D / count.to_f)]
}.to_h

items = docs.map do |d|
  d[:feature] =
    d[:feature].map {|ord, feature|
    [ord, idf[ord] * feature.to_f]
  }.to_h
  d
end

answers = categories.each_with_object({}) {|(key, value), memo|
  memo[value[:len]] = {
    count: value[:count],
    name: key,
    id: value[:len],
  }
}

pp answers
# puts({answers: answers, items: items}.to_json)

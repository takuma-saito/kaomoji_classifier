require 'json'

docs = []
freqs = {}
while (line = $stdin.gets)&.chomp!
  n = line.split("$")
  ords = n[0].chars.map(&:ord)
  ords.each {|ord|
    freqs[ord] ||= 0
    freqs[ord] += 1
  }
  docs << {
    t: n[1],
    v: n[0],
    feature: ords.reduce({}) {|memo, c|
      memo[c] ||= 0
      memo[c] += 1
      memo
    }
  }
end

D = docs.length.to_f
idf = freqs.map {|ord, count|
  [ord, Math.log(D / count.to_f)]
}.to_h

res = docs.map do |d|
  d[:feature] =
    d[:feature].map {|ord, feature|
    [ord, idf[ord] * feature.to_f]
  }.to_h
  d
end

puts res.to_json



def get_metrics(items, category)
  metrices = items.map {|_item|
    case [(_item[:answer] == category),
          (_item[:prediction] == category)]
    when [true, true]
      :tp
    when [false, true]
      :fp
    when [true, false]
      :fn
    when [false, false]
      :tn
    else
      fail
    end
  }
  {
    tp: metrices.count {|i| i == :tp},
    tn: metrices.count {|i| i == :tn},
    fp: metrices.count {|i| i == :fp},
    fn: metrices.count {|i| i == :fn}
  }
end

def success(metrics)
  ((metrics[:tp] + metrics[:tn]).to_f / metrics.values.reduce(&:+).to_f) * 100
end

def error(metrics)
  ((metrics[:fp] + metrics[:fn]).to_f / metrics.values.reduce(&:+).to_f) * 100
end

def precision(metrics)
  ((metrics[:tp]).to_f / (metrics[:tp] + metrics[:fp]).to_f ) * 100
end

def recall(metrics)
  ((metrics[:tp]).to_f / (metrics[:tp] + metrics[:fn]).to_f ) * 100
end

def f(v)
  return v if ((v.is_a? String) || (v.is_a? Integer))
  sprintf("%.2f", v)
end

items = []
while (line = $stdin.gets)&.chomp!
  d = line.split("\t").map {|item| item.split("$") }
  items << {
    answer: d[0][1],
    prediction: d[1][1],
    input: d[0][0],
  }
end

metrices =
  items.map {|item| item[:answer]}
    .uniq
    .map { |category|
  m = get_metrics(items, category)
  precision = precision(m)
  recall = recall(m)
  m.merge({
            category: category,
            success: success(m),
            error: error(m),
            precision: precision,
            recall: recall,
            f_value: (2 * (precision * recall)) / (precision + recall)
          })
}

headings = [:category, :tp, :tn, :fp, :fn,
            :success, :error, :precision, :recall, :f_value]

puts headings.join(",")
metrices.each do |metrics|
  puts headings.map {|head| f(metrics[head])}.join(",")
end
count = metrices.count
puts "total," + headings.reject {|i| i == :category}
  .map {|head|
  f(metrices.map {|metrics| metrics[head]}.reduce(&:+).to_f / count.to_f)
}.join(",")

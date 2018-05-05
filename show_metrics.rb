
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
  return v if (v.nil? || (v.is_a? String) || (v.is_a? Integer))
  sprintf("%.2f", v)
end

def calc_statistics(m)  
  precision = precision(m)
  recall = recall(m)
  {
    success: success(m),
    error: error(m),
    precision: precision,
    recall: recall,
    f_value: (2 * (precision * recall)) / (precision + recall)
  }
end

def show_metrics(metrics)  
  puts $headings.map {|head| f(metrics[head])}.join(",")
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
  m.merge(calc_statistics(m)).merge(category: category)
}
m =  [:tp, :tn, :fp, :fn].map do |field|
  [field, metrices.map {|metrics| metrics[field]}.reduce(&:+).to_f]
end.to_h
m.merge!(calc_statistics(m)).merge!(category: 'MICRO TOTAL')

$headings = [:category, :tp, :tn, :fp, :fn,
            :success, :error, :precision, :recall, :f_value]
puts $headings.join(",")
metrices.each { |metrics| show_metrics(metrics) }

macro_precision =
  metrices.map {|metrics|
  d = metrics[:tp] + metrics[:fp]
  d == 0 ? 1 : (metrics[:tp] / d.to_f)
}.reduce(&:+) / metrices.size.to_f
macro_recall =
  metrices.map {|metrics| 
  d = metrics[:tp] + metrics[:fn]
  d == 0 ? 1 : (metrics[:tp] / d.to_f)
}.reduce(&:+) / metrices.size.to_f
macro_fscore = (2 * (macro_precision * macro_recall)) / (macro_precision + macro_recall)
show_metrics(m)
puts "macro precision,#{f(macro_precision * 100)}"
puts "macro recall,#{f(macro_recall * 100)}"
puts "macro fscore,#{f(macro_fscore * 100)}"

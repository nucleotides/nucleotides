module DataProcessor

  DATA_DIR = 'tmp/'

  FIELDS = {
    '# contigs (>= 1000 bp)'   => :n_contigs_gt_1000,
    'Genome fraction (%)'      => :genome_fraction,
    'N50'                      => :n50,
    'L50'                      => :l50,
    '# mismatches per 100 kbp' => :mismatches_per_100k,
    '# N\'s per 100 kbp'       => :ns_per_100k,
    '# indels per 100 kbp'     => :indels_per_100k
  }

  FORMATTERS = {
    :genome_fraction => lambda{|i| (100 - i.to_f).round(2)}
  }


  def files
    Dir[DATA_DIR + '*'].map do |file|
      data, namespace, tool = file.gsub(DATA_DIR, '').split('_')
      {file: file, data: data, tool: tool, namespace: namespace}
    end
  end

  def parse_result(result)
    require 'csv'
    csv = CSV.parse(result, col_sep: "\t")
    csv.inject({}) do |hash, (k, v)|
      field = FIELDS[k]
      if field
        v = FORMATTERS[field].call(v) if FORMATTERS[field]
        hash[field] = v
      end
      hash
    end
  end

  def results
    files.group_by{|i| i[:data] }.map do |dataset, values|
      outputs = values.map do |v|
        results = parse_result File.read(v[:file])
        results.merge v
       end
      {:name   => dataset,
       :values => outputs }
    end
  end

  def execute!
    require 'yaml'
    puts YAML.dump results
  end

end

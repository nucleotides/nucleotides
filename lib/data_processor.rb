#!/usr/bin/env ruby

module DataProcessor

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

  def dataset_map(file_contents)
    require 'csv'
    csv = CSV.parse(file_contents, col_sep: ",", headers: true)
    csv.map{|i| Hash[i.to_hash.map{|(k,v)| [k.to_sym,v]}]}.group_by{|i| i[:dataset]}
  end

  def parse_result(file_contents)
    require 'csv'
    csv = CSV.parse(file_contents, col_sep: "\t")
    csv.inject({}) do |hash, (k, v)|
      field = FIELDS[k]
      if field
        v = FORMATTERS[field].call(v) if FORMATTERS[field]
        hash[field] = v
      end
      hash
    end
  end

  def metrics(dir)
    Dir["#{dir}/*/report.tsv"].inject({}) do |hash, file|
      _, _, digest, _ = file.split('/')
      hash[digest] = parse_result File.read(file)
      hash
    end
  end

  def create_data(file_map, metrics)
    Hash[file_map.map do |data_set, config|
      values = config.select{|i| metrics.include? i[:digest] }.map do |image|
        image.merge(metrics[image[:digest]])
      end
      [data_set, values]
    end]
  end

  def execute!(directory, master_list)
    require 'yaml'
    file_map = dataset_map(File.read(master_list))
    metrics  = metrics(directory)
    puts YAML.dump(create_data(file_map, metrics))
  end

end

include DataProcessor
execute! *ARGV

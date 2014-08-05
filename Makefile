s3 = s3cmd --config ${HOME}/.amazon-aws.cfg
bucket = s3://nucleotid-es

dir = ./tmp

all: data/benchmarks.yml

quast: $(dir)/.metrics

$(dir):
	mkdir -p $@

$(dir)/metrics: tmp
	mkdir -p $@
	$(s3) sync $(bucket)/metrics/quast/ $@

$(dir)/master.csv: tmp
	$(s3) get --force $(bucket)/evaluation_master_list.csv $@

data/benchmarks.yml: ./lib/data_processor.rb $(dir)/metrics $(dir)/master.csv
	 $^ > $@

$(dir)/contigs: tmp
	mkdir -p $@
	$(s3) sync --rexclude=".+/log.txt" $(bucket)/evaluations/ $@
	find $@/*/contigs.fa -empty | xargs rm

$(dir)/reference: tmp
	mkdir -p $@
	$(s3) sync $(bucket)/reference/ $@

$(dir)/quast: tmp/master.csv
	mkdir -p $@
	parallel \
    	  --max-procs 8 \
    	  --col-sep ',' \
    	  --header 1 \
    	  "./bin/quast {dataset} {digest} $@ $(dir)"\
    	  :::: $<

$(dir)/.metrics: $(dir)/metrics tmp
	$(s3) sync $</ $(bucket)/metrics/quast/
	touch $@

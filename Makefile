s3 = s3cmd --config ${HOME}/.amazon-aws.cfg
bucket = s3://nucleotid-es

dir = ./tmp

all: data/benchmarks.yml

$(dir):
	mkdir -p $@

$(dir)/metrics: tmp
	mkdir -p $@
	$(s3) sync $(bucket)/metrics/quast/ $@

$(dir)/master.csv: tmp
	$(s3) get --force $(bucket)/evaluation_master_list.csv $@

data/benchmarks.yml: $(dir)/metrics $(dir)/master.csv
	./lib/data_processor.rb $^ > $@

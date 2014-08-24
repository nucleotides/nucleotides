s3 = s3cmd --config ${HOME}/.amazon-aws.cfg
bucket = s3://nucleotid-es

dir = ./tmp

all: data/benchmarks.yml data/ng50_voting.yml

$(dir):
	mkdir -p $@

$(dir)/metrics: $(dir)
	mkdir -p $@
	$(s3) sync $(bucket)/metrics/quast/ $@

$(dir)/master.csv: $(dir)
	$(s3) get --force $(bucket)/evaluation_master_list.csv $@

data/benchmarks.yml: ./bin/data_processor $(dir)/metrics $(dir)/master.csv
	 $^ > $@

data/ng50_voting.yml: ./bin/voting data/benchmarks.yml data/ignore.yml
	 bundle exec $^ ng50 true > $@

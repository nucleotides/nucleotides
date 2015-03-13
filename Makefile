credentials_file = .aws_credentials
fetch_cred       = $$(./plumbing/credential/get $(credentials_file) $(1))
credentials      = AWS_SECRET_KEY=$(call fetch_cred,AWS_SECRET_KEY) \
                   AWS_ACCESS_KEY=$(call fetch_cred,AWS_ACCESS_KEY)

image = r-base

initial_data = data/data.yml data/genomes.yml data/site.yml data/images.yml
created_data = data/benchmarks.yml

##################################
#
#  Bootstrap required data
#
##################################

bootstrap: Gemfile.lock $(credentials_file) $(initial_data) .image

.image: Dockerfile
	docker build -t $(image) .

Gemfile.lock: Gemfile
	bundle install --path vendor/bundle
	touch $@

$(credentials_file): ./plumbing/credential/create
	$< $@

data/%.yml: versioned/data/%.yml
	mkdir -p $(dir $@)
	cp $< $@

data/data.yml:
	mkdir -p $(dir $@)
	wget \
	--output-document $@ \
	--quiet \
	'https://raw.githubusercontent.com/nucleotides/nucleotides-data/master/data/data.yml'

data/images.yml:
	mkdir -p $(dir $@)
	wget \
	--output-document $@ \
	--quiet \
	'https://raw.githubusercontent.com/nucleotides/nucleotides-data/master/data/image.yml'

data/evaluations.yml: data/evaluations.yml.xz
	xz --decompress < $< > $@

data/evaluations.yml.xz: Gemfile.lock
	mkdir -p $(dir $@)
	$(credentials) bundle exec \
		./plumbing/s3/fetch_evaluations $@


##################################
#
#  Run tests
#
##################################

test: Gemfile.lock
	bundle exec rspec

autotest: Gemfile.lock
	bundle exec autotest


##################################
#
#  Create intermediate data
#
##################################

data/benchmarks.yml: ./plumbing/evaluation/organise versioned/data/variable_renames.yml data/evaluations.yml
	bundle exec $^ > $@

data/modelling_inputs.csv: ./plumbing/evaluation/generate_modelling_inputs data/benchmarks.yml
	bundle exec $^ > $@

data/scores/%.csv: plumbing/docker/model plumbing/model/scores data/modelling_inputs.csv
	mkdir -p $(dir $@)
	./plumbing/docker/model $(image) $(shell grep $* versioned/data/model_types.txt) > $@

##################################
#
#  Build the website
#
##################################

dev: $(created_data) $(initial_data)
	bundle exec middleman server

build: $(created_data) $(initial_data) $(shell find source)
	bundle exec middleman build --verbose

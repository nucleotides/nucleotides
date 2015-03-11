credentials_file = .aws_credentials
fetch_cred       = $$(./plumbing/credential/get $(credentials_file) $(1))
credentials      = AWS_SECRET_KEY=$(call fetch_cred,AWS_SECRET_KEY) \
                   AWS_ACCESS_KEY=$(call fetch_cred,AWS_ACCESS_KEY)

date = $(shell date +%Y-%V)

data_objects = data/data.yml data/genomes.yml data/site.yml data/images.yml

##################################
#
#  Bootstrap required data
#
##################################

bootstrap: Gemfile.lock $(credentials_file) $(data_objects)

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
#  Build the website
#
##################################

data/benchmarks.yml: ./plumbing/evaluation/organise versioned/data/variable_renames.yml data/evaluations.yml
	bundle exec $^ > $@

dev: data/benchmarks.yml $(data_objects)
	bundle exec middleman server

build: data/benchmarks.yml $(data_objects) $(shell find source)
	bundle exec middleman build --verbose

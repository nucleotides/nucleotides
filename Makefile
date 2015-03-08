credentials_file = .aws_credentials
fetch_cred       = $$(./plumbing/credential/get $(credentials_file) $(1))
credentials      = AWS_SECRET_KEY=$(call fetch_cred,AWS_SECRET_KEY) \
                   AWS_ACCESS_KEY=$(call fetch_cred,AWS_ACCESS_KEY)

date = $(shell date +%Y-%V)

data_objects = data/benchmarks.yml data/data.yml

##################################
#
#  Bootstrap required data
#
##################################

bootstrap: Gemfile.lock $(credentials_file) data/evaluations.yml

Gemfile.lock: Gemfile
	bundle install --path vendor/bundle
	touch $@

$(credentials_file): ./plumbing/credential/create
	$< $@

data/data.yml:
	wget \
	--output-document $@ \
	--quiet \
	'https://raw.githubusercontent.com/nucleotides/nucleotides-data/master/data/data.yml'

data/evaluations.yml: data/evaluations.yml.xz
	xz --decompress < $< > $@

data/evaluations.yml.xz: Gemfile.lock
	mkdir -p $(dir $@)
	$(credentials) bundle exec \
		./plumbing/s3/fetch s3://nucleotid-es/evaluation-data/$(date)/$(notdir $@) $@

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

data/benchmarks.yml: ./plumbing/evaluation/reformat versioned/data/variable_renames.yml data/evaluations.yml
	bundle exec $^ > $@

dev: $(data_objects)
	bundle exec middleman server

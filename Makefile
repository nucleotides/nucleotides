date   = $(shell date "+%Y-%m")

s3     = s3cmd --config ${HOME}/.amazon-aws.cfg

##################################
#
#  Bootstrap required data
#
##################################

bootstrap: Gemfile.lock data/.fetched data/assemblers.yml

Gemfile.lock: Gemfile
	bundle install

data/.fetched:
	$(s3) sync s3://nucleotid-es/website-data/$(date)/ $(basename $@)
	touch $@

data/assemblers.yml:
	wget \
		https://raw.githubusercontent.com/nucleotides/assembler-list/master/assembler.yml \
		--quiet \
		--output-document $@

##################################
#
#  Building the site
#
##################################

dev: Gemfile.lock
	bundle exec middleman server

build: $(shell find source)
	rm -r $@
	bundle exec middleman build --verbose

publish: build
	git push
	$(s3) sync --delete-removed $@/* s3://nucleotidl.es/

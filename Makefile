date   = $(shell date "+%Y-%m")

s3     = s3cmd --config ${HOME}/.amazon-aws.cfg

##################################
#
#  Bootstrap required data
#
##################################

.bootstrap: Gemfile.lock .images .data data/assemblers.yml
	touch $@

Gemfile.lock: Gemfile
	bundle install

.fetched:
	mkdir -p data
	$(s3) sync s3://nucleotid-es/website-data/$(date)/ data
	touch $@

.images: .fetched
	mkdir -p source/images
	mv -f data/*.png source/images
	touch $@

.data: .fetched
	cp versioned/data/* data/
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

dev: .bootstrap
	bundle exec middleman server

build: $(shell find source) .bootstrap
	rm -fr $@
	bundle exec middleman build --verbose

publish: build
	git push
	$(s3) sync --delete-removed $@/* s3://nucleotidl.es/

clean:
	rm -rf data source/images .images .data .bootstrap .fetched

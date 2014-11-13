date   = $(shell date "+%Y-%m")

s3     = s3cmd --config ${HOME}/.amazon-aws.cfg
bucket = s3://nucleotid-es

##################################
#
#  Bootstrap required data
#
##################################

bootstrap: Gemfile.lock data/.fetched data/assemblers.yml

Gemfile.lock: Gemfile
	bundle install

data/.fetched:
	$(s3) sync $(bucket)/website-data/$(date)/ $(basename $@)
	touch $@

data/assemblers.yml:
	wget \
		https://raw.githubusercontent.com/nucleotides/assembler-list/master/assembler.yml \
		--quiet \
		--output-document $@

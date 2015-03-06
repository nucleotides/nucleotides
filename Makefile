credentials_file = .aws_credentials
fetch_cred  = $$(./plumbing/credential/get $(credentials_file) $(1))

date = $(shell date +%Y-%V)

##################################
#
#  Bootstrap required data
#
##################################

bootstrap: Gemfile.lock $(credentials_file)

Gemfile.lock: Gemfile
	bundle install --path vendor/bundle

$(credentials_file): ./plumbing/credential/create
	$< $@

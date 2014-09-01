s3     = s3cmd --config ${HOME}/.amazon-aws.cfg
bucket = s3://nucleotid-es
fetch  = $(s3) get $(bucket)/website-data/$(notdir $@) $@


all: data/benchmarks.yml data/ng50_voting.yml data/assemblers.yml

data/assemblers.yml:
	wget \
		https://raw.githubusercontent.com/nucleotides/assembler-list/master/assembler.yml \
		--output-document $@

data/ng50_voting.yml:
	$(fetch)

data/benchmarks.yml:
	$(fetch)

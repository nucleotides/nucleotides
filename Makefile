s3     = s3cmd --config ${HOME}/.amazon-aws.cfg
bucket = s3://nucleotid-es
date   = $(shell date "+%Y-%m")
fetch  = $(s3) get $(bucket)/website-data/$(date)/$(notdir $@) $@

targets = data/benchmarks.yml data/ng50_voting.yml data/accuracy_voting.yml data/assemblers.yml

all: $(targets)

data/assemblers.yml:
	wget \
		https://raw.githubusercontent.com/nucleotides/assembler-list/master/assembler.yml \
		--quiet \
		--output-document $@

data/%_voting.yml:
	$(fetch)

data/benchmarks.yml:
	$(fetch)

clean:
	rm -f $(targets)

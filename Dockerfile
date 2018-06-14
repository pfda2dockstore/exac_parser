# Generated by precisionFDA exporter (v1.0.3) on 2018-06-14 15:46:46 +0000
# The asset download links in this file are valid only for 24h.

# Exported app: exac_parser, revision: 20, authored by: arturo.pineda
# https://precision.fda.gov/apps/app-BxkG8V004Fk2XxX8X9FVyffQ

# For more information please consult the app export section in the precisionFDA docs

# Start with Ubuntu 14.04 base image
FROM ubuntu:14.04

# Install default precisionFDA Ubuntu packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
	aria2 \
	byobu \
	cmake \
	cpanminus \
	curl \
	dstat \
	g++ \
	git \
	htop \
	libboost-all-dev \
	libcurl4-openssl-dev \
	libncurses5-dev \
	make \
	perl \
	pypy \
	python-dev \
	python-pip \
	r-base \
	ruby1.9.3 \
	wget \
	xz-utils

# Install default precisionFDA python packages
RUN pip install \
	requests==2.5.0 \
	futures==2.2.0 \
	setuptools==10.2

# Add DNAnexus repo to apt-get
RUN /bin/bash -c "echo 'deb http://dnanexus-apt-prod.s3.amazonaws.com/ubuntu trusty/amd64/' > /etc/apt/sources.list.d/dnanexus.list"
RUN /bin/bash -c "echo 'deb http://dnanexus-apt-prod.s3.amazonaws.com/ubuntu trusty/all/' >> /etc/apt/sources.list.d/dnanexus.list"
RUN curl https://wiki.dnanexus.com/images/files/ubuntu-signing-key.gpg | apt-key add -

# Update apt-get
RUN DEBIAN_FRONTEND=noninteractive apt-get update

# Download helper executables
RUN curl https://dl.dnanex.us/F/D/0K8P4zZvjq9vQ6qV0b6QqY1z2zvfZ0QKQP4gjBXp/emit-1.0.tar.gz | tar xzf - -C /usr/bin/ --no-same-owner --no-same-permissions
RUN curl https://dl.dnanex.us/F/D/bByKQvv1F7BFP3xXPgYXZPZjkXj9V684VPz8gb7p/run-1.2.tar.gz | tar xzf - -C /usr/bin/ --no-same-owner --no-same-permissions

# Write app spec and code to root folder
RUN ["/bin/bash","-c","echo -E \\{\\\"spec\\\":\\{\\\"input_spec\\\":\\[\\{\\\"name\\\":\\\"exac_file\\\",\\\"class\\\":\\\"file\\\",\\\"optional\\\":false,\\\"label\\\":\\\"ExAC\\ file\\ \\(.vcf\\)\\\",\\\"help\\\":\\\"A\\ .vcf\\ file\\ from\\ ExAC\\ project\\\",\\\"default\\\":\\\"file-Bxjy5380xykq6bFj45kq51ZK\\\"\\},\\{\\\"name\\\":\\\"goi_list\\\",\\\"class\\\":\\\"file\\\",\\\"optional\\\":false,\\\"label\\\":\\\"GoI\\ list\\ file\\ \\(.txt\\)\\\",\\\"help\\\":\\\"A\\ .txt\\ file\\ containing\\ a\\ list\\ of\\ genes\\ of\\ interest\\ \\(gene\\ name,\\ chromosome,\\ start\\ and\\ stop\\ positions\\)\\\",\\\"default\\\":\\\"file-BxkFXg00q5pyYFFgk1G5x2j8\\\"\\}\\],\\\"output_spec\\\":\\[\\{\\\"name\\\":\\\"exac_filtered\\\",\\\"class\\\":\\\"file\\\",\\\"optional\\\":false,\\\"label\\\":\\\"ExAC\\ tab\\ separated\\ file\\\",\\\"help\\\":\\\"\\\"\\}\\],\\\"internet_access\\\":false,\\\"instance_type\\\":\\\"himem-8\\\"\\},\\\"assets\\\":\\[\\],\\\"packages\\\":\\[\\]\\} \u003e /spec.json"]
RUN ["/bin/bash","-c","echo -E \\{\\\"code\\\":\\\"\\\\n\\#Trim\\ the\\ file\\ to\\ the\\ first\\ 10000\\ lines\\\\n\\#head\\ -10000\\ \\\\\\\"\\$exac_file_path\\\\\\\"\\ \\\\u003e\\ exac_small.txt\\\\ncat\\ \\\\\\\"\\$exac_file_path\\\\\\\"\\ \\\\u003e\\ exac_small.txt\\\\n\\\\n\\#Header\\\\nawk\\ -F\\ \\'\\\\\\\\t\\'\\ \\ -v\\ h\\=0\\ \\'\\(NF\\=\\=8\\ \\\\u0026\\\\u0026\\ h\\=\\=0\\ \\\\u0026\\\\u0026\\ index\\(\\$0,\\\\\\\"\\#\\\\\\\"\\)\\=\\=0\\)\\ \\{printf\\ \\\\\\\"\\#CHROM\\\\\\\\tPOS\\\\\\\\tREF\\\\\\\\tALT\\\\\\\\t\\\\\\\"\\ \\;\\ split\\(\\$8,a,\\\\\\\"\\;\\\\\\\"\\)\\;\\ for\\(i\\=1\\;i\\\\u003c\\=length\\(a\\)\\;i\\+\\+\\)\\ \\{split\\(a\\[i\\],b,\\\\\\\"\\=\\\\\\\"\\)\\;\\ if\\(b\\[1\\]\\=\\=\\\\\\\"AF\\\\\\\"\\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AN\\\\\\\"\\ \\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AC\\\\\\\"\\ \\ \\|\\|\\ \\ b\\[1\\]\\=\\=\\\\\\\"AC_AMR\\\\\\\"\\ \\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AN_AMR\\\\\\\"\\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AC_FIN\\\\\\\"\\ \\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AN_FIN\\\\\\\"\\ \\ \\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AC_NFE\\\\\\\"\\ \\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AN_NFE\\\\\\\"\\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AC_SAS\\\\\\\"\\ \\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AN_SAS\\\\\\\"\\ \\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AC_EAS\\\\\\\"\\ \\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AN_EAS\\\\\\\"\\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AC_AFR\\\\\\\"\\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AN_AFR\\\\\\\"\\)\\ printf\\ b\\[1\\]\\\\\\\"\\\\\\\\t\\\\\\\"\\;\\}\\ printf\\ \\\\\\\"\\\\\\\\n\\\\\\\"\\;\\ h\\=1\\}\\'\\ exac_small.txt\\ \\\\u003e\\ exac_tab.txt\\\\n\\\\n\\#Alleles\\ for\\ genes\\ of\\ interest\\ \\(goi.txt\\)\\\\n\\{\\\\n\\\\tread\\\\n\\\\twhile\\ IFS\\=\\$\\'\\\\\\\\t\\'\\ read\\ -r\\ geneID\\ chromosome\\ startPosition\\ endPosition\\\\n\\\\tdo\\ \\\\n\\\\t\\\\t\\#echo\\ \\\\\\\"Gene\\ \\$geneID\\ is\\ in\\ chromosome\\ \\$chromosome\\ and\\ starts\\ at\\ \\$startPosition\\ and\\ ends\\ at\\ \\$endPosition\\\\\\\"\\\\n\\\\t\\\\tawk\\ -F\\ \\'\\\\\\\\t\\'\\ -v\\ ch\\=\\$chromosome\\ -v\\ st\\=\\$startPosition\\ -v\\ en\\=\\$endPosition\\ \\'\\(NF\\=\\=8\\ \\\\u0026\\\\u0026\\ index\\(\\$0,\\\\\\\"\\#\\\\\\\"\\)\\=\\=0\\ \\\\u0026\\\\u0026\\ \\$1\\=\\=ch\\ \\\\u0026\\\\u0026\\ \\$2\\\\u003e\\=st\\ \\\\u0026\\\\u0026\\ \\$2\\\\u003c\\=en\\)\\ \\{printf\\ \\$1\\\\\\\"\\\\\\\\t\\\\\\\"\\$2\\\\\\\"\\\\\\\\t\\\\\\\"\\$4\\\\\\\"\\\\\\\\t\\\\\\\"\\$5\\\\\\\"\\\\\\\\t\\\\\\\"\\;\\ split\\(\\$8,a,\\\\\\\"\\;\\\\\\\"\\)\\;\\ for\\(i\\=1\\;i\\\\u003c\\=length\\(a\\)\\;i\\+\\+\\)\\ \\{split\\(a\\[i\\],b,\\\\\\\"\\=\\\\\\\"\\)\\;\\ if\\(b\\[1\\]\\=\\=\\\\\\\"AF\\\\\\\"\\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AN\\\\\\\"\\ \\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AC\\\\\\\"\\ \\ \\|\\|\\ \\ b\\[1\\]\\=\\=\\\\\\\"AC_AMR\\\\\\\"\\ \\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AN_AMR\\\\\\\"\\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AC_FIN\\\\\\\"\\ \\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AN_FIN\\\\\\\"\\ \\ \\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AC_NFE\\\\\\\"\\ \\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AN_NFE\\\\\\\"\\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AC_SAS\\\\\\\"\\ \\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AN_SAS\\\\\\\"\\ \\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AC_EAS\\\\\\\"\\ \\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AN_EAS\\\\\\\"\\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AC_AFR\\\\\\\"\\ \\|\\|\\ b\\[1\\]\\=\\=\\\\\\\"AN_AFR\\\\\\\"\\)\\ printf\\ b\\[2\\]\\\\\\\"\\\\\\\\t\\\\\\\"\\;\\}\\ printf\\ \\\\\\\"\\\\\\\\n\\\\\\\"\\;\\}\\'\\ exac_small.txt\\ \\\\u003e\\\\u003e\\ exac_tab.txt\\\\n\\\\tdone\\\\n\\}\\ \\\\u003c\\\\\\\"\\$goi_list_path\\\\\\\"\\\\n\\\\n\\\\n\\#\\ Emit\\ the\\ output\\\\nemit\\ exac_filtered\\ exac_tab.txt\\\\n\\\"\\} | python -c 'import sys,json; print json.load(sys.stdin)[\"code\"]' \u003e /script.sh"]

# Create directory /work and set it to $HOME and CWD
RUN mkdir -p /work
ENV HOME="/work"
WORKDIR /work

# Set entry point to container
ENTRYPOINT ["/usr/bin/run"]

VOLUME /data
VOLUME /work
FROM alpine:3.13 as builder
MAINTAINER Bartosz Balis <balis@agh.edu.pl>

# Version of the job executor should be passed via docker build, e.g.: 
# docker build --build-arg hf_job_executor_version="1.1.4""
ARG hf_job_executor_version
ENV HYPERFLOW_JOB_EXECUTOR_VERSION=$hf_job_executor_version

RUN apk add git 
RUN apk add build-base
RUN apk add zlib zlib-dev

RUN git clone https://github.com/lh3/bwa bwa-src \
    && cd bwa-src \
    && make

RUN apk add ncurses-dev bzip2-dev xz-dev
ADD https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2 /samtools.tar.bz2
RUN tar jxvf /samtools.tar.bz2 && cd /samtools-1.11 && ./configure --prefix=/samtools && make && make install

FROM mhart/alpine-node:12 

RUN apk add python2 py2-numpy perl bash xz-dev

# Install HyperFlow job executor
RUN npm install -g @hyperflow/job-executor@${HYPERFLOW_JOB_EXECUTOR_VERSION}
RUN npm install -g log4js

# For testing (install hyperflow job executor from tar.gz)
#ADD hyperflow-job-executor.tar.gz /
#RUN cd /hyperflow-job-executor && npm install -g

COPY --from=builder /bwa-src/bwa /usr/local/bin
COPY --from=builder /samtools/bin/samtools /usr/local/bin
COPY software/* /usr/local/bin/

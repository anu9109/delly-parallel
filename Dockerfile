#################################################################
# Dockerfile
#
# Description:      Docker container with Delly version 0.7.3 built to enable parallel processing.
# Website:          https://github.com/tobiasrausch/delly
# Base Image:       ubuntu
# Pull Cmd:         docker pull anu9109/delly-parallel
# Run Cmd:          docker run -it anu9109/delly-parallel delly

# Adapted from "https://github.com/tobiasrausch/delly/blob/master/docker/Dockerfile"
#################################################################

# use the ubuntu base image
FROM ubuntu:14.04

# install required packages
RUN apt-get update && apt-get install -y \
    ant \
    build-essential \
    cmake \
    g++ \
    gfortran \
    git \
    hdf5-tools \
    libboost-date-time-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    libboost-iostreams-dev \
    libbz2-dev \
    libhdf5-dev \
    libncurses-dev \
    python \
    python-dev \
    python-pip \
    zlib1g-dev \
    && apt-get clean

# set environment
ENV BOOST_ROOT /usr
ENV SEQTK_ROOT /opt/htslib

# install delly
RUN cd /opt \
    && git clone https://github.com/samtools/htslib.git \
    && cd /opt/htslib \
    && make \
    && make lib-static \
    && make install
RUN cd /opt \
    && git clone https://github.com/samtools/bcftools.git \
    && cd /opt/bcftools \
    && make all \
    && make install
RUN cd /opt \
    && git clone https://github.com/samtools/samtools.git \
    && cd /opt/samtools \
    && make all \
    && make install
RUN cd /opt \
    && git clone --recursive https://github.com/tobiasrausch/delly.git \
    && cd /opt/delly/ \
    && make PARALLEL=1 -B src/delly 

# install python variant filtering dependencies
RUN cd /opt \
    && pip install -r delly/complexVariants/requirements.txt

# set environment variables
ENV PATH=$PATH:/opt/delly/src

# by default /bin/bash is executed
CMD ["/bin/bash"]

FROM fedora:35 AS build

RUN yum install -y yum-utils fedora-gnat-project-common-3.15-3.fc35.noarch gprbuild-2020-7.fc35.x86_64 gcc-gnat-11.2.1-1.fc35.x86_64 && \
    yum clean all

RUN mkdir -p /opt/app/src
WORKDIR /opt/app/src

WORKDIR /opt/app
COPY src/*.ad[sb] src/
COPY ./optimised.adc ./prime_sieve.gpr ./

RUN /usr/bin/gprbuild -p -XMODE=optimised

ENTRYPOINT ["/opt/app/sieves"]

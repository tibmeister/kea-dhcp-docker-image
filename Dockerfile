FROM debian:bullseye AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    pkg-config \
    libmysqlclient-dev \
    libboost-all-dev \
    liblog4cplus-dev \
    libssl-dev \
    libtool \
    libprotobuf-dev \
    protobuf-compiler \
    libcurl4-openssl-dev \
    git \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src

RUN git clone -b v2.4.1 https://gitlab.isc.org/isc-projects/kea.git

WORKDIR /usr/src/kea

RUN ./configure --with-dhcp-mysql --prefix=/usr/local \
    && make -j$(nproc) \
    && make install

FROM debian:bullseye

COPY --from=builder /usr/local /usr/local
RUN mkdir -p /etc/kea /var/log/kea /usr/lib/kea/hooks

COPY ./kea-config /etc/kea

VOLUME ["/etc/kea"]

EXPOSE 67/udp 8000

CMD ["/usr/local/sbin/kea-dhcp4", "-c", "/etc/kea/kea-dhcp4.conf"]
FROM debian:bullseye AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    pkg-config \
    default-libmysqlclient-dev \
    libboost-dev \
    libboost-system-dev \
    libboost-thread-dev \
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

RUN git clone -b Kea-2.6.4 https://gitlab.isc.org/isc-projects/kea.git
# RUN cd kea && \
#     git submodule update --init --recursive

WORKDIR /usr/src/kea

RUN mkdir -p /usr/src/kea/build && cd /usr/src/kea/build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DWITH_MYSQL=YES && \
    make -j$(nproc) && \
    make install


FROM debian:bullseye

COPY --from=builder /usr/local /usr/local
RUN mkdir -p /etc/kea /var/log/kea /usr/lib/kea/hooks

COPY ./kea-config /etc/kea

VOLUME ["/etc/kea"]

EXPOSE 67/udp 8000

CMD ["/usr/local/sbin/kea-dhcp4", "-c", "/etc/kea/kea-dhcp4.conf"]
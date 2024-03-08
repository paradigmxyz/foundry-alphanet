FROM ubuntu:jammy-20240212 as builder

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    git \
    libboost-all-dev \
    && \
    update-ca-certificates

ENV SOLC_COMMIT=c3af02c281f54932c0adcbdf32899d0d6e988850

# Clone the Solidity repository
RUN git clone https://github.com/ethereum/solidity.git /app/solidity

WORKDIR /app/solidity

RUN git checkout $SOLC_COMMIT

COPY ./patches/solc.diff .
RUN git apply solc.diff && \
    mkdir build && \
    cd build && \
    ls -al /app/solidity && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make solc

FROM ubuntu:jammy-20240212

# Copy the compiled solc binary to a standard location
COPY --from=builder /app/solidity/build/solc/solc /usr/local/bin/solc
RUN chmod +x /usr/local/bin/solc

# Set the entrypoint to the solc binary
ENTRYPOINT ["/usr/local/bin/solc"]

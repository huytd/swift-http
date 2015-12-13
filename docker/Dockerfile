FROM ubuntu:latest
EXPOSE 8080
RUN echo "Installing dependencies..."
RUN apt-get update && apt-get install -y --force-yes \
        wget \
        build-essential \
        clang \
        rsync \
        libpython-all-dev \
        libedit-dev \
	libxml2-dev \
        libicu52 && \
        apt-get clean
RUN cd /
RUN wget https://swift.org/builds/ubuntu1404/swift-2.2-SNAPSHOT-2015-12-10-a/swift-2.2-SNAPSHOT-2015-12-10-a-ubuntu14.04.tar.gz && \
    tar xzf swift-2.2-SNAPSHOT-2015-12-10-a-ubuntu14.04.tar.gz && \
    rsync -a -v swift-2.2-SNAPSHOT-2015-12-10-a-ubuntu14.04/usr/ /usr && \
    rm -rf swift-2.2-SNAPSHOT-2015-12-10-a-ubuntu14.04*

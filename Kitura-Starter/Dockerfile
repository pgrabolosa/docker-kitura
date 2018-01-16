FROM ibmcom/swift-ubuntu:4.0.2
MAINTAINER Pierre Grabolosa at IMERIR - based on the excellent IBM Cloud Kitura-Starter image
LABEL Description="Docker image for building and running the Kitura-based web services (includes libmysqlclient-dev for KueryMySQL)."

# Expose default port for Kitura
EXPOSE 8080

RUN mkdir /Kitura-Starter
WORKDIR /Kitura-Starter

ADD Sources /Kitura-Starter/Sources
ADD Tests /Kitura-Starter/Tests
ADD public /Kitura-Starter/public
ADD Package.swift /Kitura-Starter
ADD LICENSE /Kitura-Starter
ADD .swift-version /Kitura-Starter
RUN cd /Kitura-Starter && swift build

# Fetch libmysqlclient-dev so Kuery works 
RUN wget -q https://repo.mysql.com//mysql-apt-config_0.8.4-1_all.deb \
  && dpkg -i mysql-apt-config_0.8.4-1_all.deb \
  && apt-get update \
  && apt-get install -y libmysqlclient-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Fetch Dependencies and compile
RUN swift package clean \
  && swift build --configuration release

# Run it!
CMD ["swift", "run", "--configuration", "release"]


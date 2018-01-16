FROM ibmcom/kitura-ubuntu
COPY Kitura-Starter/ /Kitura-Starter/
WORKDIR /Kitura-Starter

# Fetch libmysqlclient-dev so Kuery works 
RUN export DEBIAN_FRONTEND=noninteractive \
  && wget -q https://repo.mysql.com//mysql-apt-config_0.8.4-1_all.deb \
  && dpkg -i mysql-apt-config_0.8.4-1_all.deb \
  && apt-get update \
  && apt-get install -y libmysqlclient-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN swift package clean \
  && swift build --configuration release

CMD ["swift", "run", "--configuration", "release"]


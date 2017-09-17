FROM swift:3.1

EXPOSE  8080

COPY Package.swift /
COPY Sources /Sources
COPY Tests /Tests

RUN swift package fetch
RUN swift build

CMD /.build/debug/vrtcl-api

FROM golang:alpine

RUN apk add --update git && rm -rf /var/cache/apk/*
RUN go get github.com/Masterminds/glide
RUN go install github.com/Masterminds/glide

# This fails
# RUN go get -d github.com/percona/mongodb_exporter
# RUN go build -o /bin/mongodb_exporter github.com/percona/mongodb_exporter

# FIX https://github.com/percona/mongodb_exporter/issues/57
RUN go get -d github.com/percona/mongodb_exporter && \
    go get github.com/kardianos/govendor && \
    cd $GOPATH/src/github.com/percona/mongodb_exporter && \
    govendor sync && \
    go build -o /bin/mongodb_exporter mongodb_exporter.go

EXPOSE 9104
ENTRYPOINT ["/bin/mongodb_exporter"]

# Build the manager binary
FROM golang:1.13 as builder

WORKDIR /go/src/github.com/fanux/sealvm
# Copy the Go Modules manifests
COPY . . 

# Build
RUN GOPROXY=https://goproxy.cn,direct CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o manager main.go

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
# FROM gcr.io/distroless/static:latest
FROM golang:1.13
WORKDIR /
COPY --from=builder /go/src/github.com/fanux/sealvm/manager .
ENTRYPOINT ["/manager"]

FROM golang:latest AS build
WORKDIR /src/
COPY . /src/
RUN curl -L https://github.com/openshift-online/ocm-cli/releases/download/v0.1.54/ocm-linux-amd64 -o ocm && chmod 755 ocm
RUN make rosa && chmod 755 rosa
RUN /src/rosa download openshift-client
RUN tar xzvf /src/openshift-client-linux.tar.gz
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
COPY --from=build /src/rosa /src/oc /src/kubectl /src/ocm /bin/
RUN microdnf install jq
CMD ["/bin/rosa"]

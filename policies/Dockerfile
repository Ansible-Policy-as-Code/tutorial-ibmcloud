FROM docker.io/openpolicyagent/opa:0.45.0-rootless

WORKDIR /app/opa/policies

COPY . .

CMD ["run", "--server", "--bundle", "."]
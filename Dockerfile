FROM golang:1.26-alpine AS build
WORKDIR /src
COPY go.mod ./
COPY go.su[m] ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/app .

FROM gcr.io/distroless/static:nonroot
WORKDIR /app
COPY --from=build /out/app /app/app
COPY --from=build /src/templates ./templates
USER nonroot
EXPOSE 8080
ENTRYPOINT ["/app/app"]

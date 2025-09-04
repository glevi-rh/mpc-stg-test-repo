# This Dockerfile uses a multi-stage build to create a small, secure, and certified image.

# --- Stage 1: The Builder Stage ---
# We use the Red Hat Go toolset image to build our application binary.
FROM registry.access.redhat.com/ubi9/go-toolset:1.24.6-1756913080 AS builder

# Set the working directory for the source code.
WORKDIR /opt/app-root/src

# Copy the Go module files to manage dependencies.
COPY go.mod go.mod

# Download the Go dependencies to cache them. This speeds up subsequent builds.
RUN go mod download

# Copy the application source code.
COPY main.go main.go

# Build the Go application binary with all dependencies statically linked.
RUN go build -a -o main main.go

# --- Stage 2: The Final Stage ---
# We use the minimal Red Hat Universal Base Image (UBI) for the final image.
# This makes the image as small as possible.
FROM registry.access.redhat.com/ubi9/ubi-minimal:9.6-1755695350

# Copy the Go binary from the builder stage into the final image's root directory.
COPY --from=builder /opt/app-root/src/main /main

# Copy the licenses directory into the final image. This is a requirement for Red Hat Certification.
# Make sure the 'licenses' directory exists in the same folder as this Dockerfile.
COPY licenses/ /licenses/

# Run the container as a non-root user for security. This is another certification requirement.
USER 65532:65532

# Set the entrypoint to run the main binary when the container starts.
ENTRYPOINT ["/main"]
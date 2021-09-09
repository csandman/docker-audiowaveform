# Docker [audiowaveform](https://github.com/bbc/audiowaveform) Alpine Builder

Build side docker container to use in multistage builds for reducing total container size

- [Source repo bbc/audiowaveform](https://github.com/bbc/audiowaveform)
- [This repo](https://github.com/csandman/docker-audiowaveform) is alpine Dockerfile with **audiowaveform** building in it
- [Docker Hub Container](https://hub.docker.com/r/csandman/audiowaveform) with compiled **audiowaveform** binaries. (**audiowaveform** and **audiowaveform_test** are in /bin directory)

## Usage in multistage builds

Link container and copy binaries from it. Don't forget about required libraries.

```Dockerfile
FROM alpine:latest

# Add audiowaveform runtime dependencies
# https://github.com/bbc/audiowaveform#package
RUN apk add --no-cache libmad libsndfile libid3tag gd boost

# Copy the static binary from this container
COPY --from=csandman/audiowaveform /bin/audiowaveform /usr/local/bin
# Optionally copy the test library over as well
# COPY --from=csandman/audiowaveform /bin/audiowaveform_test /usr/local/bin
```

### Credits

- [bbc/audiowaveform](https://github.com/bbc/audiowaveform) — The original project
- [realies/audiowaveform-docker](https://github.com/realies/audiowaveform-docker) — The first docker example
- [gsix/docker-audiowaveform-alpine](https://github.com/gsix/docker-audiowaveform-alpine) — The second docker example
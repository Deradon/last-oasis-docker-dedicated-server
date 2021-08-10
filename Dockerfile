FROM ubuntu:20.04

ENV USER=steam
ENV UID=1000
ENV GID=1001

RUN addgroup \
    --system \
    --gid "$GID" \
    "$USER"

RUN adduser \
    --disabled-password \
    --ingroup "$USER" \
    --system \
    --uid "$UID" \
    "$USER"

RUN apt update -y
RUN apt install -y \
  curl \
  lib32gcc1

RUN mkdir -p /mnt/steam
RUN chown -R steam:steam /mnt/steam/
VOLUME ["/mnt/steam/"]

USER steam
WORKDIR /home/steam

RUN mkdir /mnt/steam/Steam
RUN mkdir /mnt/steam/.steam

RUN ln -s /mnt/steam/Steam ./Steam
RUN ln -s /mnt/steam/.steam ./.steam

RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# Run once non-interative to download steam files
RUN ./steamcmd.sh --help

COPY --chown=steam ./ ./

ENTRYPOINT ["/home/steam/last-oasis"]
CMD ["help"]

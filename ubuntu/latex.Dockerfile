ARG base_tag="edge"
FROM pandoc/crossref:${base_tag}-ubuntu

# NOTE: `libsrvg`, pandoc uses `rsvg-convert` for working with svg images.
# NOTE: to maintainers, please keep this listing alphabetical.
RUN apt-get -q --no-allow-insecure-repositories update \
  && DEBIAN_FRONTEND=noninteractive \
     apt-get install --assume-yes --no-install-recommends \
        fontconfig \
        gnupg \
        gzip \
        libfontconfig1 \
        libfreetype6 \
        librsvg2-bin \
        perl \
        tar \
        wget \
        xzdec \
        && rm -rf /var/lib/apt/lists/*

# DANGER: this will vary for different distributions,
# particularly the `linux` suffix. Ubuntu linux is a glibc based
# distribution, adjust depending on the distro.
# `-linux` ----------------------------> vvvvv
ENV PATH="/opt/texlive/texdir/bin/x86_64-linux:${PATH}"
WORKDIR /root

COPY common/latex/texlive.profile /root/texlive.profile
COPY common/latex/install-texlive.sh /root/install-texlive.sh

RUN /root/install-texlive.sh

COPY common/latex/install-tex-packages.sh /root/install-tex-packages.sh
RUN /root/install-tex-packages.sh

RUN rm -f /root/texlive.profile \
          /root/install-texlive.sh \
          /root/install-tex-packages.sh

WORKDIR /data

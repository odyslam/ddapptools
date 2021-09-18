FROM ubuntu:focal

# hadolint ignore=DL3008
RUN apt-get update && apt-get install --no-install-recommends -y curl xz-utils vim  ca-certificates && apt-get clean && rm -rf /var/lib/apt/lists/* \
      && mkdir -m 0755 /nix && groupadd -r nixbld && chown root /nix \
      && for n in $(seq 1 10); do useradd -c "Nix build user $n" -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(command -v nologin)" "nixbld$n"; done
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -o pipefail && curl -L https://nixos.org/nix/install | bash

ENV USER=root
COPY install-dapptools.sh /tmp/install-dapptools.sh
RUN chmod +x /tmp/install-dapptools.sh && . "$HOME/.nix-profile/etc/profile.d/nix.sh" && /tmp/install-dapptools.sh && rm /tmp/install-dapptools.sh

COPY start-dapptools.sh /usr/sbin/start-dapptools.sh
# Add the  'source nix.sh' command to .bashrc so it's sourced
# with every new bash session  that can be invoked via docker exec -it
RUN chmod +x /usr/sbin/start-dapptools.sh &&  mkdir "$HOME/dapptools/" && \
  echo "source $HOME/.nix-profile/etc/profile.d/nix.sh" >> "$HOME/.bashrc" && \
   mkdir "$HOME/.ethereum" "$HOME/.ethereum/keystore"

WORKDIR "$HOME/dapptools/"

ENTRYPOINT ["/usr/sbin/start-dapptools.sh"]

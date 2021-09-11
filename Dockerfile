FROM ubuntu:latest

RUN apt-get update && apt-get upgrade -y && apt-get install -y curl xz-utils sudo
RUN mkdir -m 0755 /nix && groupadd -r nixbld && chown root /nix && for n in $(seq 1 10); do useradd -c "Nix build user $n" -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(command -v nologin)" "nixbld$n"; done
RUN curl -L https://nixos.org/nix/install | sh


ENV USER=root
COPY install-dapptools.sh /tmp/install-dapptools.sh
RUN chmod +x /tmp/install-dapptools.sh
RUN . "$HOME/.nix-profile/etc/profile.d/nix.sh" && /tmp/install-dapptools.sh

COPY start-dapptools.sh /usr/sbin/start-dapptools.sh
RUN chmod +x /usr/sbin/start-dapptools.sh

ENTRYPOINT ["/usr/sbin/start-dapptools.sh"]

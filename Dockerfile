# Dockerfile
# Synthetic verification image only; never deploy this fixture host.
FROM ghcr.io/jdx/mise:2026.8.2@sha256:010e6829a39dafea7a660d15d72b730023fb36ab27c65ed0d65c325d6c979a61

WORKDIR /theme
ENV MISE_TRUSTED_CONFIG_PATHS=/theme MISE_YES=1 BUNDLE_FROZEN=true
COPY . .
# Mise bootstraps the pinned tools and existing build scripts only.
RUN mise use --global ruby@4.0.5 node@24 \
    && mise exec ruby@4.0.5 node@24 -- gem install bundler -v 4.0.20 --no-document \
    && mise exec ruby@4.0.5 node@24 -- bundle install \
    && mise exec ruby@4.0.5 node@24 -- npm ci \
    && mise exec ruby@4.0.5 node@24 -- bin/build-host \
    && mise exec ruby@4.0.5 node@24 -- bin/ci \
    && mise exec ruby@4.0.5 node@24 -- bin/host-assets \
    && ln -s "$(mise where ruby@4.0.5)" /opt/verification-ruby \
    && ln -s "$(mise where node@24)" /opt/verification-node

# Runtime dispatch is direct; no mise exec or shims are needed.
ENV PATH="/opt/verification-ruby/bin:/opt/verification-node/bin:${PATH}"
ENTRYPOINT []
CMD ["bundle", "exec", "ruby", "scripts/verify_host_assets.rb"]

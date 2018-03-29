FROM haskell:7.8
RUN cabal update

# Add Cabal File and deps/ folder
COPY ./web-app.cabal /opt/server/

RUN cd /opt/server && cabal install --only-dependencies

# Explicitly add relevant folders
COPY ./src /opt/server/src

# Build the Project
RUN cd /opt/server && cabal build

FROM haskell:7.8 
COPY --from=0 /opt/server/dist/build/web-app/web-app /opt/server/

ENV PATH=/opt/server

# Default Command for Container
WORKDIR /opt/server
CMD ["web-app"]

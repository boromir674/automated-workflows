### BASE ENVS ###
# Base Env 1: For copying (ie from host)
FROM scratch AS strach_env
WORKDIR /workspace

# Base Env 2: For providing app runtime
FROM python:3.12.4-slim-bullseye AS python_env

### BUILDER ENVS ###
# Builder 1: Tooling for Docs development
FROM python_env AS install_tox
RUN pip install --user tox==3.27.1

# Builder 2: Pinned dependency versions, satisfying constraints, in /workspace
FROM strach_env AS dependencies
COPY pyproject.toml .
COPY poetry.lock .


FROM python_env AS install_docs
# Normally, we do a `poetry install` here, but we're using `tox` to manage the environment
# Instead copy the tox distribution from the install_tox image
COPY --from=install_tox /root/.local /root/.local
WORKDIR /workspace
COPY --from=dependencies /workspace .
COPY tox.ini .
RUN /root/.local/bin/tox -e pin-deps -- -E docs
RUN /root/.local/bin/tox -e docs-live --notest


### RUNTIME ENVS ###
FROM python_env AS docs
COPY --from=install_docs /workspace .
COPY --from=install_tox /root/.local /root/.local

FROM docs AS docs_gen
# requires run with volumes
# apt get install some py yaml
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3-yaml && \
    apt-get clean all

# RUN /.tox/docs-live/bin/python -m pip install pyyaml
RUN pip install pyyaml

FROM docs AS docs_live
# requires run with volumes:
#  - ./docs/:/workspace/docs/
#  - ./mkdocs.yml:/workspace/mkdocs.yml
CMD [ "/root/.local/bin/tox", "-e", "docs-live", "--", "-w", "docs", "-w", "mkdocs.yml", "-a", "0.0.0.0:8020"]


# Runtime Env 1: Docs

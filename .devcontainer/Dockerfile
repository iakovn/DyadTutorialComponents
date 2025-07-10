# Dockerfile for Julia Jupyter Notebook
FROM quay.io/jupyter/minimal-notebook:latest

# Julia dependencies
# install Julia packages in ${JULIA_INSTALL_PATH} instead of ${HOME}
ARG JULIA_INSTALL_PATH=/opt/julia

# Precompile Julia packages during docker build.
# This increases build time and image size, but speeds up the first start of the container.
ARG JULIA_DOCKER_PRECOMPILE=false

# Set this to a specific epoch time to ensure consistent precompilation cache.
# Use, e.g., git log -1 --format=%ct
ARG SOURCE_DATE_EPOCH=1700000000
ENV SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH}

USER root

RUN mkdir -p ${JULIA_INSTALL_PATH} \
    && chown -R ${NB_UID} ${JULIA_INSTALL_PATH} \
    && chmod -R 777 ${JULIA_INSTALL_PATH} \    
    && ln -s ${JULIA_INSTALL_PATH}/juliaup/bin/julia /usr/local/bin/julia

USER ${NB_UID}

ARG JULIA_DOCKER_PRECOMPILE_MARKER=${JULIA_INSTALL_PATH}/julia_docker_build_precompile

RUN DO_PRECOMPILE=$(echo "$JULIA_DOCKER_PRECOMPILE" \
      | tr '[:upper:]' '[:lower:]' \
      | sed -E 's/^(true|1|yes)$/yes/;s/^(false|0|no)$/no/') && \
    if [ "$DO_PRECOMPILE" = "yes" ]; then \
      echo "✅ JULIA_DOCKER_PRECOMPILE=$JULIA_DOCKER_PRECOMPILE will install and precompile packages" && \
      touch ${JULIA_DOCKER_PRECOMPILE_MARKER} && \
      chmod 777 ${JULIA_DOCKER_PRECOMPILE_MARKER}; \
    elif [ "$DO_PRECOMPILE" = "no" ]; then \
      echo "⏭️ JULIA_DOCKER_PRECOMPILE=$JULIA_DOCKER_PRECOMPILE will skip package compilation"; \
    else \
      echo "🚨 Invalid JULIA_DOCKER_PRECOMPILE value: '$JULIA_DOCKER_PRECOMPILE'" >&2 && \
      echo "Allowed values: true, false, yes, no, 1, 0 (case-insensitive)" >&2 && \
      exit 1; \
    fi

    # Note that both JULIAUP_DEPOT_PATH and JULIA_DEPOT_PATH are set.
# The JULIA_PKGDIR should not be needed; only for backwards compatibility.
ENV JULIAUP_DEPOT_PATH=${JULIA_INSTALL_PATH} \
    JULIA_DEPOT_PATH=${JULIA_INSTALL_PATH} \
    JULIA_PKGDIR=${JULIA_INSTALL_PATH} \
    CONDA_JL_HOME=/opt/conda \
    CONDA_JL_CONDA_EXEC=/opt/conda/bin/conda

# Release channel is needed for julia vscode extension.
# For reproducible builds, set JULIA_CHANNEL to a specific version, e.g., 1.11.5 
ARG JULIA_CHANNEL=release

# Install Julia via juliaup into ${JULIA_INSTALL_PATH}/juliaup
RUN curl -fsSL https://install.julialang.org | \
    sh -s -- -y -p ${JULIA_INSTALL_PATH}/juliaup \
            --add-to-path false \
            --background-selfupdate 0 \
            --startup-selfupdate 0 \
            --default-channel ${JULIA_CHANNEL}

ENV PATH="${JULIA_INSTALL_PATH}/juliaup/bin:${PATH}"

RUN echo "Build Conda.jl" && julia -e 'using Pkg;  Pkg.add("Conda"); Pkg.build("Conda")'

# Create system-wide shared julia env for precompilation
ARG JULIA_SHARED_ENV=${JULIA_INSTALL_PATH}/environments/shared 
RUN mkdir -p ${JULIA_SHARED_ENV}

COPY --chown=${NB_UID} environments/shared/ ${JULIA_SHARED_ENV}/
WORKDIR ${JULIA_SHARED_ENV}

RUN echo "Update manifest" && ls -l && julia --project=${JULIA_SHARED_ENV} -e 'using Pkg; Pkg.resolve();'
RUN if [ -f ${JULIA_DOCKER_PRECOMPILE_MARKER} ]; then \
      echo "Installing and precompiling." && \
      julia --project=${JULIA_SHARED_ENV} -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'; \
    else \
      echo "Updating shared manifest." &&  \
      julia --project=${JULIA_SHARED_ENV} -e 'using Pkg; Pkg.resolve()' ; \
    fi

ENV JULIA_LOAD_PATH="${JULIA_SHARED_ENV}:@:@stdlib"

# Install any additional packages or dependencies here
# Examples:
#   Same environment (version not fixed):
#   RUN julia --project=${JULIA_SHARED_ENV} -e 'using Pkg; Pkg.add("Plotly"); Pkg.precompile()'
#
#   Different environment using Project.toml & Manifest.toml (recommended):
#   COPY --chown=${NB_UID} environments/plotly/ ${JULIA_INSTALL_PATH}/environments/plotly/
#   RUN julia --project=${JULIA_INSTALL_PATH}/environments/plotly -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'
#   Stack it on top of the shared environment: 
#   ENV JULIA_LOAD_PATH="${JULIA_INSTALL_PATH}/environments/plotly:${JULIA_LOAD_PATH}"


ENV SOURCE_DATE_EPOCH=

# Set working directory
WORKDIR /workspace

# Expose default Jupyter port
EXPOSE 8888

ENV JUPYTER_ENABLE_LAB=yes

# use JuliaHub package server
ENV JULIA_PKG_SERVER=juliahub.com
ENV JULIA_PKG_USE_CLI_GIT=true
# in terminal by default activate the project in curdir
ENV JULIA_PROJECT=.

CMD ["start-notebook.sh"]

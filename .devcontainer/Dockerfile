# Dockerfile for Julia Jupyter Notebook
FROM quay.io/jupyter/minimal-notebook:latest

# Julia dependencies
# install Julia packages in ${JULIA_INSTALL_PATH} instead of ${HOME}
ARG JULIA_INSTALL_PATH=/opt/julia
ENV JULIA_DEPOT_PATH=${JULIA_INSTALL_PATH} \
    JULIA_PKGDIR=${JULIA_INSTALL_PATH} \
    CONDA_JL_HOME=/opt/conda

USER root

RUN mkdir -p ${JULIA_INSTALL_PATH} \
    && chown -R ${NB_UID} ${JULIA_INSTALL_PATH} \
    && chmod -R 777 ${JULIA_INSTALL_PATH} \
    && ln -s ${JULIA_INSTALL_PATH}/juliaup/bin/julia /usr/local/bin/julia

USER ${NB_UID}

ARG JULIA_CHANNEL=release

# ensure consistent precompile cache
ENV SOURCE_DATE_EPOCH=1710000000

# Install Julia via juliaup into ${JULIA_INSTALL_PATH}/juliaup
RUN curl -fsSL https://install.julialang.org | \
    sh -s -- -y -p ${JULIA_INSTALL_PATH}/juliaup \
            --add-to-path false \
            --background-selfupdate 0 \
            --startup-selfupdate 0 \
            --default-channel ${JULIA_CHANNEL}

ENV PATH="${JULIA_INSTALL_PATH}/juliaup/bin:${PATH}"

RUN echo "Build Conda.jl" && pwd && ls -la . && julia -e 'using Pkg;  Pkg.add("Conda"); Pkg.build("Conda")'

RUN echo "Adding IJulia" && \
    julia -e 'using Pkg; Pkg.add("IJulia"); Pkg.precompile()'

RUN echo "Adding Plots" && \
    julia -e 'using Pkg; Pkg.add("Plots"); Pkg.precompile()'

RUN echo "Adding LanguageServer" && \
    julia -e 'using Pkg; Pkg.add("LanguageServer"); Pkg.precompile()'

RUN echo "Adding REPL" && \
    julia -e 'using Pkg; Pkg.add("REPL"); Pkg.precompile()'

RUN echo "Adding InteractiveUtils" && \
    julia -e 'using Pkg; Pkg.add("InteractiveUtils"); Pkg.precompile()'


# Create system-wide shared julia env for precompilation
ARG JULIA_SHARED_ENV=${JULIA_INSTALL_PATH}/environments/shared 
RUN mkdir -p ${JULIA_SHARED_ENV}
COPY Project.toml ${JULIA_SHARED_ENV}/Project.toml
COPY Manifest.toml ${JULIA_SHARED_ENV}/Manifest.toml
COPY src/ ${JULIA_SHARED_ENV}/src/
WORKDIR ${JULIA_SHARED_ENV}

# install Jupyter Julia support and simulation packages
RUN echo "Precompile packages" && ls -l && julia --project=${JULIA_SHARED_ENV} -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'

ENV SOURCE_DATE_EPOCH=

ENV JULIA_LOAD_PATH="${JULIA_SHARED_ENV}:@:@stdlib"

# Install any additional packages or dependencies here
# Example: RUN julia -e 'using Pkg; Pkg.add("Plots"); Pkg.precompile()'

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

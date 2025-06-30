# Dockerfile for Julia Jupyter Notebook
FROM quay.io/jupyter/julia-notebook:latest

# Install any additional packages or dependencies here
# Example: RUN julia -e 'using Pkg; Pkg.add("Plots")'

# Set working directory
WORKDIR /workspace

# Expose default Jupyter port
EXPOSE 8888

ENV JUPYTER_ENABLE_LAB=yes

# Devcontainer mounts ~/.julia to host.
ENV JULIA_DEPOT_PATH=/home/jovyan/.julia
ENV JULIA_PKGDIR=/home/jovyan/.julia
# use JuliaHub package server
ENV JULIA_PKG_SERVER=https://juliahub.com
# in terminal by default activate the project in curdir
ENV JULIA_PROJECT=.

CMD ["start-notebook.sh"]

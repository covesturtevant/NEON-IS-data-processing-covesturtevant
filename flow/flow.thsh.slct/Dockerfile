# Dockerfile for NEON IS Data Processing - Threshold selection by date, source-id, term and context

# Start with the neon-is-pack-qaqc-r image. 
FROM quay.io/battelleecology/neon-is-pack-qaqc-r:v0.0.15

# maintainer handle
MAINTAINER "Cove Sturtevant" csturtevant@battelleecology.org

# Copy the lockfile and restore known working versions of R dependency packages
COPY ./renv.lock /renv.lock
RUN R -e 'renv::restore(lockfile="/renv.lock")'

# Copy in workflow
COPY ./flow.thsh.slct.R /flow.thsh.slct.R



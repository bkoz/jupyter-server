FROM registry.access.redhat.com/ubi8/ubi
LABEL maintainer="Bob Kozdemba <bkozdemba@gmail.com>"

RUN yum install -y python39
# WORKDIR /app
# COPY ./requirements.txt ./app ./

### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/app-root
RUN mkdir -p ${APP_ROOT}/{bin,src} && \
    chmod -R u+x ${APP_ROOT}/bin && chgrp -R 0 ${APP_ROOT} && chmod -R g=u ${APP_ROOT}
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}

WORKDIR ${APP_ROOT}/src
COPY . ${APP_ROOT}/src

RUN pip3 install jupyterlab

### Containers should NOT run as root as a good practice
USER 1001
# RUN ./fetch_models.sh

EXPOSE 8888

# VOLUME ${APP_ROOT}/logs ${APP_ROOT}/models

CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--no-browser"]

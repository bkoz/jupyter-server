FROM registry.access.redhat.com/ubi8/ubi
LABEL maintainer="Bob Kozdemba <bkozdemba@gmail.com>"

RUN yum install -y python39
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
RUN yum clean all && yum clean metadata && yum clean dbcache && yum makecache && yum update -y
RUN yum install -y code 

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

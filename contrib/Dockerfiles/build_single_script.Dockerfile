ARG DOCKER_IMAGE_BASE
FROM ${DOCKER_IMAGE_BASE}

USER user
WORKDIR /home/user

ARG SCRIPT_ARGS
ARG SCRIPT

RUN echo ${SCRIPT_ARGS}
ADD /scripts/${SCRIPT} ${HOME}/${SCRIPT}
RUN ${HOME}/${SCRIPT} ${SCRIPT_ARGS}

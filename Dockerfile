FROM funnyzak/git-webhook-node

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vendor="potato<silenceace@gmail.com>" \
    org.label-schema.name="GitWebhookNodeBuild" \
    org.label-schema.build-date="${BUILD_DATE}" \
    org.label-schema.description="Pulling the source code is triggered via WebHook, then build the source code. And send notifications before and after the Pull Code." \
    org.label-schema.url="https://yycc.me" \
    org.label-schema.schema-version="1.0"	\
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-ref="${VCS_REF}" \
    org.label-schema.vcs-url="https://github.com/funnyzak/git-webhook-node-build-docker" 

# Install nginx
RUN apk update && apk upgrade && \
    apk add --no-cache nginx && \
    rm  -rf /tmp/* /var/cache/apk/*

# fixed nginx: [emerg] open() "/run/nginx/nginx.pid" 
# https://github.com/gliderlabs/docker-alpine/issues/185
RUN mkdir -p /run/nginx

# Copy after package files run script
COPY scripts/run_scripts_after_package.sh /usr/bin/run_scripts_after_package.sh

# add permission for after package files run script
RUN chmod +x /usr/bin/run_scripts_after_package.sh

# Copy Custom Scripts
COPY custom_scripts/utils.sh /custom_scripts/potato/utils-git-webhook-node.sh
COPY custom_scripts/on_startup/run.sh /custom_scripts/on_startup/3.sh
COPY custom_scripts/before_pull/run.sh /custom_scripts/before_pull/3.sh
COPY custom_scripts/after_pull/run.sh /custom_scripts/after_pull/3.sh
COPY custom_scripts/after_package/run.sh /custom_scripts/after_package/3.sh

# add permission for custom script
RUN chmod +x -R /custom_scripts

# copy nginx conf
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# create final target folder
RUN mkdir -p /app/target/

# Source Folder
WORKDIR /app/code

# Expose port
EXPOSE 80 9000

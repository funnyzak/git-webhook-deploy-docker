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


# Copy Scripts
COPY scripts/func.sh /custom_scripts/func.sh
COPY scripts/on_startup.sh /custom_scripts/on_startup/aaa.sh
COPY scripts/before_pull.sh /custom_scripts/before_pull/aaa.sh
COPY scripts/after_pull.sh /custom_scripts/after_pull/aaa.sh

RUN chmod +x -R /custom_scripts

# create final target folder
RUN mkdir -p /app/target/

# Copy Webhook config
COPY hooks.json /app/hook/hooks.json

WORKDIR /app/code

# Expose Webhook port
EXPOSE 9000

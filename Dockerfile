FROM funnyzak/git-webhook:v2

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vendor="potato<silenceace@gmail.com>" \
    org.label-schema.name="GitWebhookDeploy" \
    org.label-schema.build-date="${BUILD_DATE}" \
    org.label-schema.description="Pull code is triggered via WebHook, then deploy And send notifications." \
    org.label-schema.url="https://yycc.me" \
    org.label-schema.schema-version="1.0"	\
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-ref="${VCS_REF}" \
    org.label-schema.vcs-url="https://github.com/funnyzak/git-webhook-deploy-docker" 

# Copy Custom Scripts
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

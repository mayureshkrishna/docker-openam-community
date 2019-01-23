FROM tomcat:7.0.79-jre7

MAINTAINER mayureshkrishna@gmail.com

ARG OPENAM_HOST=openam.lab.dc.amdtron.com
ARG OPENAM_ADMIN_PASSWORD=management
ARG OPENAM_DEPLOYMENT_URI=openam
ARG OPENAM_HTTPS=true
ARG TOMCAT_HTTP_PORT=8080
ARG TOMCAT_HTTPS_PORT=8443

ENV OPENAM_HOST=${OPENAM_HOST}
ENV OPENAM_ADMIN_PASSWORD=${OPENAM_ADMIN_PASSWORD}
ENV OPENAM_DEPLOYMENT_URI=${OPENAM_DEPLOYMENT_URI}
ENV OPENAM_VERSION=11.0.3
ENV TOMCAT_HTTPS=${TOMCAT_HTTPS}
ENV TOMCAT_HTTP_PORT=${TOMCAT_HTTP_PORT}
ENV TOMCAT_HTTPS_PORT=${TOMCAT_HTTPS_PORT}

ENV CATALINA_OPTS="-Xmx2048m -server"

RUN curl "https://maven.forgerock.org/repo/community/org/forgerock/ce/openam/openam-server/${OPENAM_VERSION}/openam-server-${OPENAM_VERSION}.war" -o $CATALINA_HOME/webapps/${OPENAM_DEPLOYMENT_URI}.war
RUN curl "https://maven.forgerock.org/repo/community/org/forgerock/ce/openam/openam-configurator-tool/${OPENAM_VERSION}/openam-configurator-tool-${OPENAM_VERSION}.jar" -o /tmp/openam-configurator-tool-${OPENAM_VERSION}.jar

RUN keytool -genkey -noprompt \
    -alias tomcat \
    -dname "CN=${OPENAM_HOST}, OU=IT, O=Society, L=Paris, S=France, C=FR" \
    -keystore ${CATALINA_HOME}/conf/keystore \
    -storepass password \
    -keypass password \
    -keyalg RSA \
    -keysize 4096 \
    -validity 720

RUN keytool -export -keystore ${CATALINA_HOME}/conf/keystore -alias tomcat -file /tmp/tomcat.cer
RUN keytool -import -noprompt -trustcacerts -alias tomcat -file /tmp/tomcat.cer -keystore /tmp/cacerts.jks -keypass password -storepass password

RUN cp $CATALINA_HOME/conf/server.xml $CATALINA_HOME/conf/server.xml.orig
COPY server.xml $CATALINA_HOME/conf/server.xml
RUN sed -i "s/%%TOMCAT_HTTP_PORT%%/${TOMCAT_HTTP_PORT}/g" ${CATALINA_HOME}/conf/server.xml
RUN sed -i "s/%%TOMCAT_HTTPS_PORT%%/${TOMCAT_HTTPS_PORT}/g" ${CATALINA_HOME}/conf/server.xml

COPY openam-build.sh /tmp/
RUN chmod +x /tmp/openam-build.sh
RUN /tmp/openam-build.sh

EXPOSE ${TOMCAT_HTTP_PORT}
EXPOSE ${TOMCAT_HTTPS_PORT}

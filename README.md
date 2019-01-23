# Docker image for OpenAM (community version 11.0.3) 

# How to use

## Quick run

```sh
$ docker build . -t openam
$ docker run -it --rm --add-host "openam.lab.dc.amdtron.com:127.0.0.1" -p 8443:8443 openam
```

Update your /etc/hosts file on your host machine if necessary.

## Default build parameters

* OPENAM_HTTPS: **true**
* TOMCAT_HTTPS_PORT: **8443**
* TOMCAT_HTTP_PORT: **8080**
* OPENAM_HOST: **openam.lab.dc.amdtron.com**
* OPENAM_DEPLOYMENT_URI: **openam** (Specifies OpenAM war file name that will be deployed inside tomcat)
* OPENAM_ADMIN_PASSWORD: **management**

## Custom configuration

Some examples:

```sh
$ docker build . -t openam \
--build-arg OPENAM_HOST=demo.openam.com \
--build-arg OPENAM_DEPLOYMENT_URI=sso \
--build-arg OPEANM_ADMIN_PASSWORD=P@ssw0rd \
--build-arg OPENAM_HTTPS=false \
--build-arg TOMCAT_HTTP_PORT=8888
$ docker run -it --rm --add-host "demo.openam.com:127.0.0.1" -p 8888:8888 openam
```

```sh
$ docker build . -t openam \
--build-arg OPENAM_HOST=custom.openam.com \
--build-arg OPENAM_DEPLOYMENT_URI=sso \
--build-arg OPEANM_ADMIN_PASSWORD=M@n@g3 \
--build-arg OPENAM_HTTPS=true \
--build-arg TOMCAT_HTTPS_PORT=8443
$ docker run -it --rm --add-host "custom.openam.com:127.0.0.1" -p 8443:8443 openam
```

In case OPENAM_HTTPS is set to **true**, OpenAM will be configured using HTTPS. Tomcat HTTPS connector is configured using a generated self signed certificate.


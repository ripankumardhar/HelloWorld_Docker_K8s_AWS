FROM openjdk:8-alpine

# Required for starting application up.
RUN apk update && apk add /bin/sh

RUN mkdir -p /opt/app
ENV PROJECT_HOME /opt/app

COPY target/hello_world.jar $PROJECT_HOME/hello_world.jar

WORKDIR $PROJECT_HOME

CMD ["java" ,"-jar","./hello_world.jar"]

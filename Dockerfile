FROM benjvi/app-mvn-cached:0 
COPY src /app/src
COPY pom.xml /app/
RUN cd /app && mvn clean verify

FROM fabric8/java-jboss-openjdk8-jdk
COPY --from=0 /app/target/helloworld-1.0.jar $JAVA_APP_DIR
ENV JAVA_APP_JAR=helloworld-1.0.jar

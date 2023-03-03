JAVA_HOME=/opt/jdk-11
CLASSPATH=client/build/libs/client-all.jar
JAVA_OPTS="-Dfile.encoding=utf8"
export JAVA_HOME FIT_PRODUCTS_BASE CLASSPATH JAVA_OPTS

${JAVA_HOME}/bin/java ${JAVA_OPTS} client.Sample_ja

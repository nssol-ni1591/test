#/opt/jdk-1.8/bin/javac -d WEB-INF/classes -encoding utf8 -cp svfrclient.jar\;/opt/apache-tomcat-9.0.63/lib/servlet-api.jar $*
JAVA_HOME=/opt/jdk-11
CLASSPATH=svfrclient.jar\;/opt/apache-tomcat-9.0.63/lib/servlet-api.jar\;WEB-INF/classes
#JAVA_OPTS="-encoding utf8 -d WEB-INF/classes"
# for cygterm
JAVA_OPTS="-J-Dfile.encoding=utf8 -d WEB-INF/classes"
export JAVA_HOME CLASSPATH JAVA_OPTS

#/opt/jdk-11/bin/javac ${JAVA_OPTS} Sample_ja.java
#/opt/jdk-11/bin/javac ${JAVA_OPTS} Sample_sl.java
#/opt/jdk-11/bin/javac ${JAVA_OPTS} SocketClient.java
#/opt/jdk-11/bin/javac ${JAVA_OPTS} SocketClientServlet.java

SRCS="Sample_ja.java Sample_sl.java SocketClient.java SocketClientServlet.java"
${JAVA_HOME}/bin/javac ${JAVA_OPTS} ${SRCS}

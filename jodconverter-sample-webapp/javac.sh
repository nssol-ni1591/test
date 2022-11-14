JAVA_HOME=/opt/jdk-1.8

[ ! -d build ] && mkdir build
[ ! -d build/WEB-INF ] && mkdir build/WEB-INF
[ ! -d build/WEB-INF/classes ] && mkdir build/WEB-INF/classes

CLASSPATH=`find lib | tr '\n' '\\;'`
CLASSPATH=${CLASSPATH}\;/opt/apache-tomcat-10.0.23/lib/servlet-api.jar
${JAVA_HOME}/bin/javac -Xdiags:verbose -d build/WEB-INF/classes/ -cp ${CLASSPATH} src/main/java/org/jodconverter/sample/webapp/*.java
[ $? -ne 0 ] && exit $?

#(cd build ; jar cf ../jodconverter-sample-webapp.war *)
cd build
cp -p ../src/main/webapp/*.js .
cp -p ../src/main/webapp/*.jsp .
cp -p ../src/main/resources/log4j.properties WEB-INF/classes
cp -pr ../lib WEB-INF
jar cf ../lool.war *
echo "[Info] Generated lool.war"

scp -p ../lool.war svf@172.16.4.84:
#expect -c "
#set timeout 5
#spawn scp -p ../lool.war svf@172.16.4.84:
#expect \"password\" {
#send -- P@ssw0rd\n
#}
#interacts
#"
echo "[Info] Copied lool.war"

cd ..
[ -d build ] && rm -rf build


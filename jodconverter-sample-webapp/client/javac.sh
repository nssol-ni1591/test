PATH=/opt/jdk-1.8/bin:${PATH}
CLASSPATH1=`find test1-libs | tr '\n' '\\;'`
CLASSPATH2=`find test2-libs | tr '\n' '\\;'`

javac -encoding utf8 -d classes -cp classes\;${CLASSPATH1} src/Test1.java
[ $? -ne 0 ] && exit $?

javac -encoding utf8 -d classes -cp classes\;${CLASSPATH2} src/Test2.java
[ $? -ne 0 ] && exit $?
javac -encoding utf8 -d classes -cp classes\;${CLASSPATH2} src/Test3.java
[ $? -ne 0 ] && exit $?

[ ! -f classes/log4j.properties ] && cp -p ../src/main/resources/log4j.properties classes
echo "[Info] Generated class files under classes"

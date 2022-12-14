CLASSPATH=`find test1-libs | tr '\n' '\\;'`
CLASSPATH=classes\;${CLASSPATH}
java -cp ${CLASSPATH} Test1 $*

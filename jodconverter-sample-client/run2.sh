CLASSPATH=`find test2-libs | tr '\n' '\\;'`
CLASSPATH=classes\;${CLASSPATH}
java -cp ${CLASSPATH} Test2 $*

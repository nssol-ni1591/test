[ ! -d WEB-INF ] && mkdir WEB-INF
[ ! -d WEB-INF/classes ] && mkdir WEB-INF/classes
[ ! -d WEB-INF/lib ] && mkdir WEB-INF/lib
[ ! -f WEB-INF/lib/svfrclient.jar ] && cp -p svfrclient.jar WEB-INF/lib
[ ! -f WEB-INF/classes/svfrclient.properties ] && cp -p svfrclient.properties WEB-INF/classes
/opt/jdk-11/bin/jar -J-Dfile.encoding=utf8 cvf svf.war index.html WEB-INF
scp svf.war svf@172.30.143.98:/tmp/sample

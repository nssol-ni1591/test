# About
jodconverterリモートを使用してOpenOfficeのpdf変換を行うためのソースファイル一式

- jodconverter-sample-webapp
    - OpenOffice G/W用servlet
    - gradle warで生成したlool.warファイルをtomcat 10.0系のAPサーバに配置する


- jodconverter-sample-client
    - テスト用クライアントアプリ
      第1引数：上記サーブレットが配置されたURL、第2引数：変換元ファイルへのパス

	    - Test2 (ファイル版)
  	  - Test3 (ストリーム版)

		※Test1はSPRINGアプリがベースのためコンパイルに失敗する。このため、project-topに配置する

- introduction_logs
		- tomcat10.service
		- staging-SVF.txt
		- production-SVF.txt

# Compile / Run method
gradleプロジェクトにファイルを展開したのちにbuildする

- $ gradlew build

※gradleプロジェクトの生成方法などは省略

### webapp
 以下のファイルをtomcatに配布する
 
- jodconverter-sample-webapp/build/libs/lool.war

### client
実行例（Test3の場合）

- $ cd jodconverter-sample-client
- $ java -jar ./build/libs/jodconverter-sample-client-all.jar [URL] 変換ファイル

本番			http://172.30.83.9:8080/
ミニ本番	http://172.30.83.79:8080/
IT				http://172.30.83.80:8080/
TetraLink	http://172.16.4.84:6384/

# Required libraries
### webapp
- commons-logging-1.2.jar
- gson-2.8.6.jar
- jodconverter-core-4.4.2.jar
- jodconverter-local-4.4.2.jar
- juh-4.1.2.jar
- jurt-4.1.2.jar
- log4j-1.2.17.jar
- ridl-4.1.2.jar
- slf4j-api-1.7.30.jar
- slf4j-nop-1.7.36.jar
- unoil-4.1.2.jar

### client
- commons-logging-1.2.jar
- fluent-hc-4.5.13.jar
- gson-2.8.6.jar
- httpclient-4.5.13.jar
- httpcore-4.4.14.jar
- httpmime-4.5.13.jar
- jodconverter-core-4.4.2.jar
- jodconverter-remote-4.4.2.jar
- slf4j-api-1.7.30.jar
- slf4j-nop-1.7.36.jar

### History
javaからOpenOfficeを使用したpdf変換には以下のライブラリが存在する

- org.artofsolving.jodconverter

  - 現行で使用しているライブラリ（Last update: 2.2.2:2009-04-11）
  - OprnOffice.org（サーバ側のプロセス）とp2p通信
  - OpenOffice.orgは常駐プロセスとして実行しておく必要がある
  - 基本的にファイルへのパスで受け渡しするので、
    クライアントとOpenOffice.orgで同じパスに入出力ファイルが存在する必要がある
  - このため、OpenOffice.orgと異なるホストで実行する場合は同一パスに見せかけるための仕組みが必要
  - 2009年以降の修正なし

- org.jodconverter

  - 上記ライブラリの後継（Last update: 4.4.4:Sep 22, 2022）
  - LocalConverterとRemoteConverterをサポート
  - RemoteConverterを実行するためにはOpenOffice.orgとの間にAPサーバが必要
  - APサーバのプログラムでOpenOffice.orgを制御するため、個別にOpenOffice.orgを実行する必要はなし
  - RemoteConverterは変換元ファイルをhttpのMultipartで送信し、変換結果を受信する
  - ファイルで入出力することも可能
  - APサーバのプログラムはサンプルとして提供（jodconverter-samples）

@see https://github.com/sbraconnier/jodconverter/
@see https://github.com/sbraconnier/jodconverter/wiki/LibreOffice-Remote
@see https://qiita.com/nkk777dev/items/82a63c956d8771663d29

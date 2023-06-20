# OpenOffice / SVF

## jodconverter

OpenOfficeとの連携ライブラリ：JodConverterを使用したGW用servletとテスト用クライアント

### jodconverter-sample-client

JodConverterをリモートから使用するクライアントプログラム

内部的にjodconverter-sample-webappにhttpリクエストを発行する

- 要件
  - required jdk-1.8 over

### jodconverter-sample-webapp

JodConverterをリモートから使用するためのGW用サーブレット

- 要件
  - required tomcat-servlet-api 10.0 over
  - required jdk-1.8 over

## svf

SVFサーバ接続用サンプル

### client

- 要件
  - required jdk-11 over
    - jdk-11からのhttpクライアントクラスを使用するため

#### Sample_ja

- SVFサンプルを使用したソース
- SVFライブラリ：SvfrClientを使用してpdf生成

#### SocketClient

- SVFサーバとソケット通信を使用したpdf生成
- httpリクエストの返信メッセージのBODYを出力する

### webapp

- 要件
  - required tomcat-servlet-api 9.0 over
  - required jdk-11 over
    - 内部的にclientのクラスを使用しているので、clientのjdkのverと合わせること

#### Sample_sl

- Sample_jaをAPサーバで実行するためのサーブレット

#### SocketClientServlet

- SocketClientをAPサーバで実行するためのサーブレット

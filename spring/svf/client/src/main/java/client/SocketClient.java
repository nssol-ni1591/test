package client;

import java.net.*;
import java.net.http.*;

/**
 * ソケット通信(クライアント側)
 */
public class SocketClient {

	public String run() throws Exception {

		//HTTPクライアント生成
		HttpClient client = HttpClient.newHttpClient();
	 	//リクエスト準備
	 	HttpRequest req = HttpRequest.newBuilder()
	   		.uri(URI.create("http://172.30.143.98:44090/"))
	   		.build();
	 	//レスポンス取得
	 	HttpResponse<?> res = client.send(req, HttpResponse.BodyHandlers.ofString());
//	 	System.out.println(res.body());
	 	//<!DOCTYPE html><html><head><meta charset="utf-8" /><title>Qiita</title><meta content="Qiitaは、プログラマのための技術情報共有サービスです。 プログラミングに関するTips、ノウハウ、メモを簡単に記録 &amp;amp; 公開することができます。"(略)
		 return res.body().toString();
   }

	public static void main(String[] args) {
		try {
			SocketClient sc = new SocketClient();
			String body = sc.run();
			System.out.println(body);
		}
		catch (Exception ex) {
			ex.printStackTrace();
		}
	}
}
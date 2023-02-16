package ftp;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.SocketException;
import java.util.Arrays;

public class FtpMain {

	private FTPClient cli;
	private int rep;

	public int getReplyCode() {
		return rep;
	}

	// コンストラクタ
	public FtpMain() {
		cli = new FTPClient();
	}

	// 接続
	public void connect(String host) throws IOException {
		System.out.println("start: connect host=[" + host + "]");
		cli.connect(host);
		System.out.println("end: connect");
	}

	// ログイン
	public void login(String user, String pass) throws IOException {
		System.out.println("start: login user=[" + user + "] pass=[" + pass + "]");
		cli.login(user, pass);
		System.out.println("end: login");
	}

	// ダウンロード
	public void downLoad() {
		FileOutputStream outputstream;
		boolean isRetrieve;

		System.out.println("start: downLoad");
		try {
			outputstream = new FileOutputStream("download.txt");
			isRetrieve = cli.retrieveFile("download.txt", outputstream);
			outputstream.close();
			if (!isRetrieve) {
				System.out.println("error: downLoad");
			}
			System.out.println("end: downLoad");
			return;
		} catch (IOException ie) {
			return;
		}
	}

	// アップロード
	public void upLoad() {
		FileInputStream inputstream;
		boolean isStore;

		System.out.println("start: upLoad");
		try {
			inputstream = new FileInputStream("upload.txt");
			isStore = cli.storeFile("upload.txt", inputstream);
			inputstream.close();
			if (!isStore) {
				System.out.println("error: upLoad");
			}
			System.out.println("end: upLoad");
			return;
		} catch (IOException ie) {
			return;
		}
	}
	
	public void setPassive() throws IOException {
		System.out.println("start: setPassive");
		cli.enterLocalPassiveMode();
//		cli.pasv();
		System.out.println("end: setPassive");
	}
	public String[] listNames(String path) throws IOException {
		System.out.println("start: listNames path=[" + path + "]");
		String[] names;
		if (path == null) {
			names = cli.listNames();			
		}
		else {
			names = cli.listNames(path);
		}
		if (names == null) {
			System.out.println("\tlistNames: ReplyCode=" + cli.getReplyCode());
		}
		System.out.println("end: listNames names=[" + names + "]");
		return names;
	}

	// 切断
	public void disconnect() throws IOException {
		System.out.println("start: disConnect");
		cli.disconnect();
		System.out.println("end: disConnect");
	}

	public static void main(String[] args) {

		if (args.length < 3 || args.length > 4) {
			System.out.println("Error: args=[" + args.length + "]");
			System.out.println("Usage: java ftp.FtpMain host user pass [path]");
			System.exit(1);
		}
		String host = args[0];
		String user = args[1];
		String pass = args[2];
		String path = args.length <= 3 ? null : args[3];

		FtpMain ftp = new FtpMain();
		try {
			ftp.connect(host);;
			ftp.login(user, pass);
			ftp.setPassive();
//			Arrays.stream(ftp.listNames(path))
//				.map(name -> "\t" + name)
//				.forEach(System.out::println);
			System.out.println(">>> names=[" + String.join(",", ftp.listNames(path)) + "]");
		}
		catch (SocketException e) {
			System.out.println("catch SocketException: ReplyCode=" + ftp.getReplyCode());
			e.printStackTrace();
		}
		catch (IOException e) {
			System.out.println("catch IOException: ReplyCode=" + ftp.getReplyCode());
			e.printStackTrace();
		}
		finally {
			try {
				ftp.disconnect();
			}
			catch (IOException e) { }
		}
		System.exit(0);
	}
}

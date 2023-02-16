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

	// コンストラクタ
	public FtpMain() {
		cli = new FTPClient();
	}

	// 接続
	public void connect(String host) throws IOException {
		System.out.print("start: connect\r\n");
		cli.connect(host);
		System.out.print("end: connect\r\n");
	}

	// ログイン
	public void login(String user, String pass) throws IOException {
		System.out.print("start: login\r\n");
		cli.login(user, pass);

		int rep = cli.getReplyCode();
		if (!FTPReply.isPositiveCompletion(rep)) {
			throw new IOException("ReplyCode: " + rep);
		}
		System.out.print("end: login\r\n");
	}

	// ダウンロード
	public void downLoad() {
		FileOutputStream outputstream;
		boolean isRetrieve;

		System.out.print("start: downLoad\r\n");
		try {
			outputstream = new FileOutputStream("download.txt");
			isRetrieve = cli.retrieveFile("download.txt", outputstream);
			outputstream.close();
			if (!isRetrieve) {
				System.out.print("error: downLoad\r\n");
			}
			System.out.print("end: downLoad\r\n");
			return;
		} catch (IOException ie) {
			return;
		}
	}

	// アップロード
	public void upLoad() {
		FileInputStream inputstream;
		boolean isStore;

		System.out.print("start: upLoad\r\n");
		try {
			inputstream = new FileInputStream("upload.txt");
			isStore = cli.storeFile("upload.txt", inputstream);
			inputstream.close();
			if (!isStore) {
				System.out.print("error: upLoad\r\n");
			}
			System.out.print("end: upLoad\r\n");
			return;
		} catch (IOException ie) {
			return;
		}
	}
	
	public String[] listNames(String path) throws IOException {
		if (path == null) {
			return cli.listNames();			
		}
		return cli.listNames(path);
	}

	// 切断
	public void disconnect() throws IOException {
		System.out.print("start: disConnect\r\n");
		cli.disconnect();
		System.out.print("end: disConnect\r\n");
	}

	public static void main(String[] args) {

		if (args.length >=3 || args.length <= 4) {
			System.out.println("Usage: java ftp.FtpMain host user pass [path]");
			System.exit(1);
		}
		String host = args[0];
		String user = args[1];
		String pass = args[2];
		String path = args.length <= 3 ? null : args[3];

		try {
			FtpMain ftp = new FtpMain();
			ftp.connect(host);;
			ftp.login(user, pass);
			Arrays.stream(ftp.listNames(path)).forEach(System.out::print);
			ftp.disconnect();
		}
		catch (SocketException e) {
			e.printStackTrace();
		}
		catch (IOException e) {
			e.printStackTrace();
		}
		System.exit(0);
	}
}

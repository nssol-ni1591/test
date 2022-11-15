import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;

import com.artofsolving.jodconverter.DefaultDocumentFormatRegistry;
import com.artofsolving.jodconverter.DocumentConverter;
import com.artofsolving.jodconverter.DocumentFormat;
import com.artofsolving.jodconverter.openoffice.connection.OpenOfficeConnection;
import com.artofsolving.jodconverter.openoffice.connection.SocketOpenOfficeConnection;
import com.artofsolving.jodconverter.openoffice.converter.OpenOfficeDocumentConverter;

class Test1 {

	public static void main(String[] args) {

		if (args.length < 2) {
			System.err.println();
			System.err.println("[Error] Not enough arguments\n");
			System.err.println("Usage: java -cp ... Test1 'OpenOffice.org hostname' 'convert file' \n");
			System.exit(1);
		}

		// 変換ファイル出力元
		File inFile = new File(args[1]);
		// 変換ファイル出力先
		String name = inFile.toString();
		int point = name.lastIndexOf(".");
	    if (point != -1) {
	        name = name.substring(0, point);
	    } 
		File outFile = new File(name + ".pdf");

		System.out.println("remoteHost=[" + args[0] + "]");
		System.out.println("inFile=[" + inFile + "]");
		System.out.println("outFile=[" + outFile + "]");

		OpenOfficeConnection connection = null;
		try {
			// ドキュメントフォーマットを作成する
			DefaultDocumentFormatRegistry documentFormatRegistry = new DefaultDocumentFormatRegistry();
			DocumentFormat outFormat = documentFormatRegistry.getFormatByFileExtension("pdf");

			// OpenOffice.org のポートに接続
//			connection = new SocketOpenOfficeConnection("localhost", 8100);
//			connection = new SocketOpenOfficeConnection("172.16.4.84", 6383);
//			connection = new SocketOpenOfficeConnection("127.0.0.1", 6383);
			connection = new SocketOpenOfficeConnection(args[0], 6383);
			connection.connect();

			// ファイルを変換
			DocumentConverter converter = new OpenOfficeDocumentConverter(connection);
			converter.convert(inFile, outFile, outFormat);

		} catch (Exception ex) {
			ex.printStackTrace();
//			System.out.println(("PDF変換に失敗しました. [" + ex.getMessage() + "]");
		} finally {
			// OpenOfficeのコネクションを閉じる
			if (connection.isConnected()) {
				connection.disconnect();
			}
		}
	}

	
	/*
	 * from jp/co/nssol/jkm/dcs/web/common/DocCommon.java#L313
	 */

	public static File convertPdf(byte[] inData, String inFormat, String convertHtmlExtension,
			String convertEncodeExtension, String name) throws Exception {

		// 引数で渡された情報をローカル環境に出力する
		File outDir = new File("out" + File.separator + System.currentTimeMillis());
		// フォルダを作成
		outDir.mkdirs();
		// ファイル名
		String pdfFileName = "temp" + "." + inFormat;
		// ファイル出力
		File inFile = new File(name);
		makeBinaryFile(new File("." + File.separator + pdfFileName), inData);

		File htmlFile = null;

		// HTMLに変換する拡張子をチェックする
		if (convertHtmlExtension != null && convertHtmlExtension.toLowerCase().indexOf(inFormat.toLowerCase()) >= 0) {
			// 変換対象の拡張子の場合、HTML変換する
//			htmlFile = createHtml(inFile, convertEncodeExtension);
		}

		// ドキュメントフォーマットを作成する
		DefaultDocumentFormatRegistry documentFormatRegistry = new DefaultDocumentFormatRegistry();
		DocumentFormat outFormat = documentFormatRegistry.getFormatByFileExtension("pdf");

		// OpenOffice.org のポートに接続
		OpenOfficeConnection connection = new SocketOpenOfficeConnection(8100);

		File outFile = null;
		try {
			// 変換ファイル出力先
			outFile = new File("out" + File.separator + "temp" + "." + "pdf");

			connection.connect();
			// 変換
			DocumentConverter converter = new OpenOfficeDocumentConverter(connection);
			if (htmlFile != null) {
				// HTMLを変換
				converter.convert(htmlFile, outFile, outFormat);
			} else {
				// ファイルを変換
				converter.convert(inFile, outFile, outFormat);
			}

			return outFile;

		} catch (Exception ex) {
			throw new Exception("PDF変換に失敗しました. [" + ex.getMessage() + "]");
		} finally {
			// OpenOfficeのコネクションを閉じる
			if (connection.isConnected()) {
				connection.disconnect();
			}

//			if (!dNLogger.isDebugEnabled()) {
			// 不要ファイルを削除する
			if (inFile != null) {
				inFile.delete();
			}
			if (htmlFile != null) {
				htmlFile.delete();
			}
//			}
		}
	}

	/**
	 * バイナリデータをファイルに出力.
	 *
	 * @param binaryData 入力バイナリデータ
	 * @param file       出力するファイル名
	 * @throws IOException 入出力例外
	 * @return File 作成済ファイル
	 */
	public static File makeBinaryFile(File file, byte[] binaryData) throws IOException {
		BufferedOutputStream bufOutStream = null;
		BufferedInputStream bufInStream = null;

		try {
			// BufferedOutStream
			bufOutStream = new BufferedOutputStream(new FileOutputStream(file));

			// BufferedInputStream生成
			// ファイルデータのbyte配列をInputStreamに変換
			bufInStream = new BufferedInputStream(new ByteArrayInputStream(binaryData));

			// 読み込み、書き込み
			byte[] buf = new byte[4096];
			int size = -1;
			while ((size = bufInStream.read(buf)) != -1) {
				bufOutStream.write(buf, 0, size);
			}
			// クローズ
			bufInStream.close();
			bufOutStream.close();
			return file;
		} catch (UnsupportedEncodingException uee) {
			throw uee;
		} catch (FileNotFoundException fnfe) {
			throw fnfe;
		} catch (IOException ie) {
			throw ie;
		} finally {
			try {
				if (bufInStream != null) {
					bufInStream.close();
				}
				if (bufOutStream != null) {
					bufOutStream.close();
				}
			} catch (Exception ex2) {
				ex2.printStackTrace();
			}
		}
	}

}

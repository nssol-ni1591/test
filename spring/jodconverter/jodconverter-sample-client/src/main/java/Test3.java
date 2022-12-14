
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;

import org.jodconverter.core.DocumentConverter;
import org.jodconverter.core.document.DocumentFormat;
import org.jodconverter.core.document.DocumentFormatRegistry;
import org.jodconverter.remote.RemoteConverter;
import org.jodconverter.remote.office.RemoteOfficeManager;
import org.jodconverter.core.office.OfficeException;
import org.jodconverter.core.office.OfficeManager;

public class Test3 {

//	public static String URL = "http://localhost:8080");
	public static String URL = "http://172.16.4.84:6384";
	private final String url;

	public Test3() {
		this.url = URL;
	}
	public Test3(String url) {
		this.url = url;
	}

	public void run(String inFile) throws OfficeException {
		OfficeManager officeManager = RemoteOfficeManager.make(url);
		DocumentConverter converter = RemoteConverter.make(officeManager);

		System.out.println("officeManager start");
		officeManager.start();
		try {
			System.out.println("convert start");

			// source stream
			InputStream is = new FileInputStream(inFile);

			// target stream
			String name = inFile;
			int point = name.lastIndexOf(".");
		    if (point != -1) {
		        name = name.substring(0, point);
		    } 
			OutputStream os = new FileOutputStream(name + ".pdf");

			// format of target stream (pdf)
			DocumentFormatRegistry registry = converter.getFormatRegistry();
			DocumentFormat pdf = registry.getFormatByExtension("pdf");

			// run converter
			converter.convert(is).to(os).as(pdf).execute();

			System.out.println("convert end");

		} catch (FileNotFoundException ex) {
			ex.printStackTrace();
		} finally {
			officeManager.stop();
		}
	}

	public static void main(String... args) throws OfficeException {

		if (args.length < 1) {
			System.err.println();
			System.err.println("[Error] Required to convert file\n");
			System.err.println("Usage: java -cp ... Test3 [url] 'convert file' \n");
			System.exit(1);
		}

		if (args.length == 1) {
			try {
				new Test3().run(args[0]);
			}
			catch (OfficeException ex) {
				ex.printStackTrace();
			}
		}
		else {
			try {
				new Test3(args[0]).run(args[1]);
			}
			catch (OfficeException ex) {
				ex.printStackTrace();
			}
		}
	}
}


import java.io.File;

import org.jodconverter.core.DocumentConverter;
import org.jodconverter.remote.RemoteConverter;
import org.jodconverter.remote.office.RemoteOfficeManager;
import org.jodconverter.core.office.OfficeException;
import org.jodconverter.core.office.OfficeManager;

public class Test2 {

//	public static String URL = "http://localhost:8080");
	public static String URL = "http://172.16.4.84:6384";
	private final String url;

	public Test2() {
		this.url = URL;
	}
	public Test2(String url) {
		this.url = url;
	}

	public void run(String inFile) throws OfficeException {
		OfficeManager officeManager = RemoteOfficeManager.make(url);
		DocumentConverter converter = RemoteConverter.make(officeManager);

		System.out.println("officeManager start");
		officeManager.start();
		try {
			System.out.println("convert start");

			// before file
			File excelFile = new File(inFile);

			// converted file
			String name = excelFile.getName();
			int point = name.lastIndexOf(".");
		    if (point != -1) {
		        name = name.substring(0, point);
		    } 
			File pdfFile = new File(name + ".pdf");

			// run converter
			converter.convert(excelFile).to(pdfFile).execute();

			System.out.println("convert end");
		} finally {
			officeManager.stop();
		}
	}
	

	public static void main(String... args) {

		if (args.length < 1) {
			System.err.println();
			System.err.println("[Error] Required to convert file\n");
			System.err.println("Usage: java -cp ... Test2 [url] 'convert file' \n");
			System.exit(1);
		}

		if (args.length == 1) {
			try {
				new Test2().run(args[0]);
			}
			catch (OfficeException ex) {
				ex.printStackTrace();
			}
		}
		else {
			try {
				new Test2(args[0]).run(args[1]);
			}
			catch (OfficeException ex) {
				ex.printStackTrace();
			}
		}
	}
}

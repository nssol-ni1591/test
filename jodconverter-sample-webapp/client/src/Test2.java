
import java.io.File;

import org.jodconverter.core.DocumentConverter;
import org.jodconverter.remote.RemoteConverter;
import org.jodconverter.remote.office.RemoteOfficeManager;
import org.jodconverter.core.office.OfficeException;
import org.jodconverter.core.office.OfficeManager;

public class Test2 {

	public static void main(String... args) throws OfficeException {

		if (args.length < 1) {
			System.err.println();
			System.err.println("[Error] Required to convert file\n");
			System.err.println("Usage: java -cp ... Test2 'convert file' \n");
			System.exit(1);
		}

//		OfficeManager officeManager = RemoteOfficeManager.make("http://localhost:8080");
		OfficeManager officeManager = RemoteOfficeManager.make("http://172.16.4.84:6384");
		DocumentConverter converter = RemoteConverter.make(officeManager);

		System.out.println("officeManager start");
		officeManager.start();
		try {
			System.out.println("convert start");

			// before file
			File excelFile = new File(args[0]);

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
}

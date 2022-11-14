
import java.io.File;
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

			// before stream
			InputStream is = new FileInputStream(args[0]);

			// converted stream
			String name = args[0];
			int point = name.lastIndexOf(".");
		    if (point != -1) {
		        name = name.substring(0, point);
		    } 
			OutputStream os = new FileOutputStream(name + ".pdf");

			// format of os 
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
}

/*
 * Sample_ja.java 2013/04/18
 * SVF for Excel
 * Sample Program
 */

//import jp.co.fit.vfreport.Vrw32;
import java.io.*;
import jp.co.fit.vfreport.SvfrClient;

public class Sample_ja {

  public static int run() throws IOException {
    int ret;

    //   Vrw32 svf = new Vrw32();
    //	SvfrClient svf = new SvfrClient("172.30.143.98", 44090);
	  SvfrClient svf = new SvfrClient();

    //言語ロケールの設定
    ret = svf.VrSetLocale("ja");
    ret = svf.VrInit("MS932");
    //SVF環境設定で作成したプリンタ名を第２パラメータで指定します
//    ret = svf.VrSetPrinter("", "EXCEL");
    ret = svf.VrSetPrinter("PDF", "PDF");
    ret = svf.VrSetSpoolFileName2("sample_ja.pdf");
    ret = svf.VrSetForm("svfjpd/Sample/excel/sample_ja.xml", 4);
    ret = svf.VrsOut("発行年月日", "2013/03/01");
    ret = svf.VrsOut("発注番号", "1000476");
    ret = svf.VrsOut("仕入先名", "ウイングアーク株式会社");
    ret = svf.VrsOut("仕入先住所", "東京都○○区□□町△△1-1-1");
    ret = svf.VrsOut("仕入先電話番号", "03-1234-5678");
    ret = svf.VrsOut("支払条件", "納入翌月末現金払");
    ret = svf.VrsOut("納品場所", "〒222-2222 東京都○△区□○町2-2-2");
    ret = svf.VrsOut("発注明細番号", "1000522");
    ret = svf.VrsOut("商品名", "SVFX-Designer");
    ret = svf.VrsOut("単価", "700000");
    ret = svf.VrsOut("数量", "2");
    ret = svf.VrsOut("仕入先製品番号", "SVF01");
    ret = svf.VrEndRecord();

    ret = svf.VrsOut("発行年月日", "2013/03/01");
    ret = svf.VrsOut("発注番号", "1000476");
    ret = svf.VrsOut("仕入先名", "ウイングアーク株式会社");
    ret = svf.VrsOut("仕入先住所", "東京都○○区□□町△△1-1-1");
    ret = svf.VrsOut("仕入先電話番号", "03-1234-5678");
    ret = svf.VrsOut("支払条件", "納入翌月末現金払");
    ret = svf.VrsOut("納品場所", "〒222-2222 東京都○△区□○町2-2-2");
    ret = svf.VrsOut("発注明細番号", "1000523");
    ret = svf.VrsOut("商品名", "SVF for Java Print");
    ret = svf.VrsOut("単価", "600000");
    ret = svf.VrsOut("数量", "3");
    ret = svf.VrsOut("仕入先製品番号", "SVF02");
    ret = svf.VrEndRecord();

    ret = svf.VrsOut("発行年月日", "2013/03/01");
    ret = svf.VrsOut("発注番号", "1000476");
    ret = svf.VrsOut("仕入先名", "ウイングアーク株式会社");
    ret = svf.VrsOut("仕入先住所", "東京都○○区□□町△△1-1-1");
    ret = svf.VrsOut("仕入先電話番号", "03-1234-5678");
    ret = svf.VrsOut("支払条件", "納入翌月末現金払");
    ret = svf.VrsOut("納品場所", "〒222-2222 東京都○△区□○町2-2-2");
    ret = svf.VrsOut("発注明細番号", "1000524");
    ret = svf.VrsOut("商品名", "SVF for PDF");
    ret = svf.VrsOut("単価", "800000");
    ret = svf.VrsOut("数量", "1");
    ret = svf.VrsOut("仕入先製品番号", "SVF03");
    ret = svf.VrEndRecord();

    ret = svf.VrPrint();
    ret = svf.VrQuit();
    return ret;
  }

  public static void main(String[] args) {
    try {
      Sample_ja.run();
      System.out.println("request success ... see sample_ja.pdf");
    }
    catch (IOException ex) {
	    ex.printStackTrace();
    }
  }
}


import thx.csv.Csv;
import haxe.Http;
import sys.io.File;


/*

  Output format for ichibastatus.csv:

  Product Code, Status, Last Checked, Check Successful?

 */

typedef ProductStatus = {
 productCode : String,
 status      : String,
 lastChecked : Date,
 checkSucessful : Bool
}

class IchibaScraper {

  private static var defautInFile : String = "ichibalinks.txt";
  private static var defaultOutFile : String = "ichibastatus.csv";

  private static var csvHeaders = "Product Code, Status, Last Checked, Check Successful?";

  public static function main () {
    var links = processLinkFile( defautInFile );
    var productStatuses = scrapeLinks( links );
    try {
      var r1 = Http.requestUrl("https://www.python.org");
      trace(r1.length);
      var r2 = Http.requestUrl("http://not.exists.io");
      trace(r2.length);
    } catch (e : Dynamic) {
      trace(e);
    }
    
  }

  private static function processLinkFile(f : String) {
    var contents = File.getContent( f );
    return contents.split("\n");    
  }

  private static function statusToCSV (ss : Array<ProductStatus>) {
    var dat = [];
    for (s in ss) {
      var a = [s.productCode, s.status, s.lastChecked.toString(),
	       Std.string( s.checkSucessful )];
      dat.push( a );
    }
    return Csv.encode( dat );
  }

  private static function scrapeLinks ( links : Array<String> ) {
    var ps : Array<ProductStatus> = [];
    for (link in links) {
      var date = Date.now();
      try {
	var pagetext = Http.requestUrl( l );
	var status = scrapeStatus( pagetext );
	ps.push( mkProductStatus( l, status, d) );
      } catch (e : Dynamic) {
	ps.push( errorCheckingLink( l , d ));
      }
    }
    return ps;
  }

  private static function productCodeFromUrl ( l : String) {
    return l.split("=")[1];
  }
  
  private static function errorCheckingLink( l : String, d : Date) {
    return {productCode : productCodeFromUrl( l ),
	status: " ",
	lastChecked: d,
	checkSucessful: false};
  }

  private static function mkProductStatus( l : String, s : String, d : Date) {
    return {productCode: productCodeFromUrl( l ),
	status: s, lastChecked: d, checkSucessful: true};
  }

  private static function scrapeStatus( txt : String ) {
    
  }
  
}
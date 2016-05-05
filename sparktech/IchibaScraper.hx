
import thx.csv.Csv;
import haxe.Http;
import sys.io.File;
import htmlparser.HtmlDocument;


typedef ProductStatus = {
 productCode : String,
 status      : String,
 lastChecked : Date,
 checkSucessful : Bool
}

class IchibaScraper {


  private static var USER_AGENTS =
    ["Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) Gecko/20100101 Firefox/46.0",
     "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36",
     
     
				    ];
  private static var POLITENESS_PERIOD = 5.0;
  private static var defautInFile : String = "ichibalinks.txt";
  private static var defaultOutFile : String = "ichibastatus.csv";

  private static var csvHeaders = "Product Code, Status, Last Checked, Check Successful?";

  public static function main () {
    var links = processLinkFile( defautInFile );
    var productStatuses = scrapeLinks( [links[0]] );
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
    for (l in links) {
      var d = Date.now();
      try {
	trace('trying to get $l');
	var pagetext = Http.requestUrl( l );
	trace('got it');
	var status = scrapeStatus( pagetext );
	trace('scrapped status');
	ps.push( mkProductStatus( l, status, d) );
      } catch (e : Dynamic) {
	ps.push( errorCheckingLink( l , d ));
      }
      Sys.sleep( POLITENESS_PERIOD);
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

  private static function scrapeStatus( htmltext : String ) {
    var doc = new HtmlDocument( htmltext, true );
    var found = doc.find("meta");
    trace(found);
    return "";
  }
  
}

import thx.csv.Csv;
import haxe.Http;
import sys.io.File;
import htmlparser.HtmlDocument;

using Lambda;

typedef ProductStatus = {
 productCode : String,
 status      : String,
 lastChecked : Date,
 checkSucessful : Bool
}

class IchibaScraper {


  public static var USER_AGENTS =
    ["Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) Gecko/20100101 Firefox/46.0",
     "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36",
     "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.94 Safari/537.36",
     "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:42.0) Gecko/20100101 Firefox/42.0",
     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2486.0 Safari/537.36 Edge/13.10586",
     "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.75 Safari/537.36",
     "Mozilla/5.0 (Windows NT 6.1; rv:33.0) Gecko/20100101 Firefox/33.0"];


  public static function randomUserAgent() {
    return USER_AGENTS[Std.int(Math.floor(USER_AGENTS.length * Math.random()))];
  }

  public static var POLITENESS_PERIOD = 3.5;
  public static var defautInFile : String = "ichibalinks.txt";
  public static var defaultOutFile : String = "ichibastatus.csv";

  public static var csvHeaders = "Product Code, Status, Last Checked, Check Successful?\n";

  public static function main () {
    var links = processLinkFile( defautInFile );
    var productStatuses = scrapeLinks( links );
    var builtCSV = statusToCSV( productStatuses );
    File.saveContent( defaultOutFile, csvHeaders + builtCSV);    
  }

  public static function processLinkFile(f : String) {
    var contents = File.getContent( f );
    return contents.split("\n").map(StringTools.trim).filter(function (s) {
	return StringTools.startsWith(s, "http://");
      });    
  }

  public static function statusToCSV (ss : Array<ProductStatus>) {
    var dat = [];
    for (s in ss) {
      var a = [s.productCode, s.status, s.lastChecked.toString(),
	       Std.string( s.checkSucessful )];
      dat.push( a );
    }
    return Csv.encode( dat );
  }

  public static function scrapeLinks ( links : Array<String> ) {
    var ps : Array<ProductStatus> = [];

    for (l in links) {

      var d = Date.now();
      var r = new haxe.Http( l );

      r.setHeader("User-Agent", randomUserAgent() );

      r.onData = function (pagetext) {
	var status = scrapeStatus( pagetext );
	trace('${productCodeFromUrl(l)} : $status');
	ps.push( mkProductStatus( l, status, d) );
      };

      r.onError = function (e) {
	trace('http error: $e for link $l');
	ps.push( errorCheckingLink( l, d) );
      };

      try {
	r.request( false );
      } catch (e : Dynamic) {
	trace('error: $e for link $l');
	ps.push( errorCheckingLink( l, d) );
      }
      
      Sys.sleep( POLITENESS_PERIOD );
    }
    return ps;
  }

  public static function productCodeFromUrl ( l : String) {
    return l.split("=")[1];
  }
  
  public static function errorCheckingLink( l : String, d : Date) {
    return {productCode : productCodeFromUrl( l ),
	status: " ",
	lastChecked: d,
	checkSucessful: false};
  }

  public static function mkProductStatus( l : String, s : String, d : Date) {
    return {productCode: productCodeFromUrl( l ),
	status: s, lastChecked: d, checkSucessful: true};
  }

  public static function scrapeStatus( htmltext : String ) {
    var doc = new HtmlDocument( htmltext, true );
    var found = doc.find('meta');
    for (f in found) 
      if (f.getAttribute('itemprop') == 'availability')
	return f.getAttribute('content');
    return "Out Of Stock";
  }
  
}
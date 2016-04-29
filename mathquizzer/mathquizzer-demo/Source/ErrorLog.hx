package;

enum ErrorKind {
  Dummy;
}

class ErrorLog {

  var log : Map<String,Int>;
  
  public function new () {
    log = new Map();
  }

  public function report (s : String) {
    var exists = log.get(s);
    if (exists == null) {
      log.set(s, 1);
    } else {
      log.set(s, exists + 1);
    }
  }


  public function generateReport () {
    var rep : Array<String> = [];

    for (k in log.keys())
      rep.push( k + ": " + Std.string(log.get(k)));

    return rep;
  }
  
}
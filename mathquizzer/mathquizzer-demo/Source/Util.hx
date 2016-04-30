package;

using Lambda;

class Util {

  public static function digits (i : Int) : Array<Int> {
    return Std.string( i ).split( "" ).map( Std.parseInt );
  }

  // NB! padLeft mutates its first argument
  public static function padLeft<T> (a : Array<T> , padding : T, size : Int) {
    while (a.length < size) a.unshift(padding);
    return a;
  }

  public static function randInt (i : Int) {
    return Std.int(Math.floor(Math.random() * i));
  }

  // NB! alters array!
  public static function randomize<T> (a: Array<T>) {
    var l = a.length;
    for (i in 0...l) {
      var i1 = randInt( l );
      var i2 = randInt( l );
      var tmp = a[i1];
      a[i1] = a[i2];
      a[i2] = tmp;
    }
      
  }
  
}
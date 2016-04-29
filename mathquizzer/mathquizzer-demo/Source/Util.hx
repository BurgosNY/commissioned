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
  
}
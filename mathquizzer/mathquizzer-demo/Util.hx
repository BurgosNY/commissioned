package;

using Lambda;

class Util {

  public static function digits (i : Int) : Array<Int> {
    return Std.string( i ).split( "" ).map( Std.parseInt );
  }

}
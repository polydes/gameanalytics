package extension.ga._internal;

class DefineMacro
{
  private static macro function getDefine(key : String) : haxe.macro.Expr
  {
    return macro $v{haxe.macro.Context.definedValue(key)};
  }
}
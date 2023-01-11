package extension.ga;

#if cpp
import cpp.Lib;
import Type;
#else
#if android
import openfl.Lib;
#end
#end

import lime.system.JNI;

import extension.ga._internal.DefineMacro;
#if html5
import extension.ga.js.GameAnalyticsJS;
#end
import extension.ga.GADef;

#if ios
@:buildXml('<include name="${haxelib:extension-ga}/project/Build.xml"/>')
//This is just here to prevent the otherwise indirectly referenced native code from bring stripped at link time.
@:cppFileCode('extern "C" int gameanalytics_register_prims();void extension_gameanalytics_link(){gameanalytics_register_prims();}')
#end
class GameAnalytics
{
  //versioning
  private static inline var sdk_version:String = "3.0.1"; //GameAnalytics SDK version

  public static function initialize(gameKey:String, secretKey:String)
  {
    /*configureSdkVersion();
    configureEngineVersion();*/
    callFunction("initialize", [gameKey, secretKey]);
  }

  #if html5
  //todo: implement for other platforms
  public static function setEnabledEventSubmission(enable:Bool)
  {
    callFunction("setEnabledEventSubmission", [enable]);
  }
  #end

  public static function setEnabledVerboseLog(enable:Bool)
  {
    callFunction("setEnabledVerboseLog", [enable]);
  }

  public static function setEnabledInfoLog(enable:Bool)
  {
    callFunction("setEnabledInfoLog", [enable]);
  }

  public static function configureUserId(user_id:String)
  {
    callFunction("configureUserId", [user_id]);
  }

  public static function configureBuild(build:String)
  {
    callFunction("configureBuild", [build]);
  }

  public static function configureAvailableResourceCurrencies(currencies:String)
  {
    callFunction("configureAvailableResourceCurrencies", [stringToList(currencies)]);
  }

  public static function configureAvailableResourceItemTypes(itemTypes:String)
  {
    callFunction("configureAvailableResourceItemTypes", [stringToList(itemTypes)]);
  }

  public static function configureAvailableCustomDimensions01(customDim:String)
  {
    callFunction("configureAvailableCustomDimensions01", [stringToList(customDim)]);
  }

  public static function configureAvailableCustomDimensions02(customDim:String)
  {
    callFunction("configureAvailableCustomDimensions02", [stringToList(customDim)]);
  }

  public static function configureAvailableCustomDimensions03(customDim:String)
  {
    callFunction("configureAvailableCustomDimensions03", [stringToList(customDim)]);
  }

  public static function setCustomDimension01(customDim:String)
  {
    callFunction("setCustomDimension01", [customDim]);
  }

  public static function setCustomDimension02(customDim:String)
  {
    callFunction("setCustomDimension02", [customDim]);
  }

  public static function setCustomDimension03(customDim:String)
  {
    callFunction("setCustomDimension03", [customDim]);
  }

  public static function setGender(gender:GAGender)
  {
    callFunction("setGender", [GADef.genderToNative(gender)]);
  }

  public static function setBirthYear(birthYear:Int)
  {
    callFunction("setBirthYear", [birthYear]);
  }

  //events
  public static function sendDesignEvent(eventId:String)
  {
    #if (android || ios)
    callFunction("addDesignEventWithEventId", [eventId]);
    #end
    callFunction("addDesignEvent", [eventId]);
  }

  public static function sendDesignEventWithAmount(eventId:String, amount:Float)
  {
    #if (android || ios)
    callFunction("addDesignEventWithAmount", [eventId, amount]);
    #end
    callFunction("addDesignEvent", [eventId, amount]);
  }

  public static function sendBusinessEventIOS(currency:String, amountInCents:Int, itemType:String, itemId:String, cartType:String, receipt:String)
  {
    callFunction("addBusinessEvent", [currency, amountInCents, itemType, itemId, cartType, receipt]);
  }

  public static function sendBusinessEventAndroid(currency:String, amountInCents:Int, itemType:String, itemId:String, cartType:String, receipt:String, signature:String)
  {
    callFunction("addBusinessEvent", [currency, amountInCents, itemType, itemId, cartType, receipt, signature]);
  }

  public static function sendBusinessEventJs(currency:String, amountInCents:Int, itemType:String, itemId:String, cartType:String)
  {
    callFunction("addBusinessEvent", [currency, amountInCents, itemType, itemId, cartType]);
  }

  public static function sendResourceEvent(flowType:GAFlowType, currency:String, amount:Int, itemType:String, itemId:String)
  {
    callFunction("addResourceEvent", [GADef.flowToNative(flowType), currency, amount, itemType, itemId]);
  }

  public static function sendProgressionEvent(status:GAProgression, progression01:String, ?progression02:String, ?progression03:String, score:Int=0)
  {
    #if (android || ios)
    if(progression02 == null) progression02 = 'empty';
    if(progression03 == null) progression03 = 'empty';
    #end
    callFunction("addProgressionEvent", [GADef.progressionToNative(status), progression01, progression02, progression03, score]);
  }

  public static function sendErrorEvent(severity:GAErrorSeverity, message:String)
  {
    callFunction("addErrorEvent", [GADef.errorToNative(severity), message]);
  }

  // SDK state
  private static function configureSdkVersion()
  {
    callFunction("configureSdkGameEngineVersion", ["stencyl " + sdk_version]);
  }

  private static function configureEngineVersion()
  {
    var engineVersion = "stencyl " + @:privateAccess DefineMacro.getDefine("stencyl");

    callFunction("configureGameEngineVersion", [engineVersion]);
  }

  //Manual session handling
  public static function setEnabledManualSessionHandling(enable:Bool)
  {
    callFunction("setEnabledManualSessionHandling", [enable]);
  }

  public static function startSession()
  {
    callFunction("startSession", []);
  }

  public static function endSession()
  {
    callFunction("endSession", []);
  }

  //Command Centre
  public static function isCommandCenterReady():Bool
  {
    return callFunction("isCommandCenterReady", []);
  }

  public static function getCommandCenterValueAsString(key:String):String
  {
    return callFunction("getCommandCenterValueAsString", [key]);
  }

  public static function getCommandCenterValueAsStringWithDefVal(key:String, defaultValue:String):String
  {
    #if html5
    return callFunction("getCommandCenterValueAsString", [key, defaultValue]);
    #else
    return callFunction("getCommandCenterValueAsStringWithDefVal", [key, defaultValue]);
    #end
  }

  //Utility
  private static function printMessage(message:String)
  {
    #if ios
    callFunction("print", [message]);
    #end
  }

  //helpers
  #if (android || ios)
  private static inline function stringToList(string:String):String
  {
    //for android/ios, turn into a list on the native side
    return string;
  }
  #else
  private static inline function stringToList(string:String):Array<String>
  {
    return string.split(",");
  }
  #end

  //multi-platform glue

  private static var functionPointerList:Map<String,Dynamic> = [];

  private static function loadFunction(functionName:String, argCount:Int):Dynamic
  {
    #if android
    if(functionPointerList[functionName] == null)
    {
      functionPointerList[functionName] = JNI.createStaticMethod("com/gameanalytics/MyGameAnalytics", functionName, ARG_TYPES[functionName], true);
    }
    #elseif ios
    if(functionPointerList[functionName] == null)
    {
      var iosFunction = Lib.load("gameanalytics", functionName + "GA", argCount);
      functionPointerList[functionName] = switch(argCount) {
        case 0: function(args:Array<Dynamic>) iosFunction();
        case 1: function(args:Array<Dynamic>) iosFunction(args[0]);
        case 2: function(args:Array<Dynamic>) iosFunction(args[0], args[1]);
        case 3: function(args:Array<Dynamic>) iosFunction(args[0], args[1], args[2]);
        case 4: function(args:Array<Dynamic>) iosFunction(args[0], args[1], args[2], args[3]);
        case 5: function(args:Array<Dynamic>) iosFunction(args[0], args[1], args[2], args[3], args[4]);
        case 6: function(args:Array<Dynamic>) iosFunction(args[0], args[1], args[2], args[3], args[4], args[5]);
        default: throw '$argCount-argument case not handled';
      };
    }
    #elseif html5
    if(functionPointerList[functionName] == null)
    {
      functionPointerList[functionName] = switch(argCount) {
        case 0: function(args:Array<Dynamic>) GameAnalyticsJS.GameAnalytics(functionName);
        case 1: function(args:Array<Dynamic>) GameAnalyticsJS.GameAnalytics(functionName, args[0]);
        case 2: function(args:Array<Dynamic>) GameAnalyticsJS.GameAnalytics(functionName, args[0], args[1]);
        case 3: function(args:Array<Dynamic>) GameAnalyticsJS.GameAnalytics(functionName, args[0], args[1], args[2]);
        case 4: function(args:Array<Dynamic>) GameAnalyticsJS.GameAnalytics(functionName, args[0], args[1], args[2], args[3]);
        case 5: function(args:Array<Dynamic>) GameAnalyticsJS.GameAnalytics(functionName, args[0], args[1], args[2], args[3], args[4]);
        default: throw '$argCount-argument case not handled';
      };
    }
    #end
    return functionPointerList[functionName];
  }

  private static inline function callFunction(functionName:String, args:Array<Dynamic>):Dynamic
  {
    var func = functionPointerList[functionName];
    if(func == null) func = loadFunction(functionName, args.length);
    return func(args);
  }

  #if android
  private static final ARG_TYPES = [
    "initialize" => "(Ljava/lang/String;Ljava/lang/String;)V",
    "setEnabledVerboseLog" => "(Z)V",
    "setEnabledInfoLog" => "(Z)V",
    "configureUserId" => "(Ljava/lang/String;)V",
    "configureBuild" => "(Ljava/lang/String;)V",
    "configureAvailableResourceCurrencies" => "(Ljava/lang/String;)V",
    "configureAvailableResourceItemTypes" => "(Ljava/lang/String;)V",
    "configureAvailableCustomDimensions01" => "(Ljava/lang/String;)V",
    "configureAvailableCustomDimensions02" => "(Ljava/lang/String;)V",
    "configureAvailableCustomDimensions03" => "(Ljava/lang/String;)V",
    "setCustomDimension01" => "(Ljava/lang/String;)V",
    "setCustomDimension02" => "(Ljava/lang/String;)V",
    "setCustomDimension03" => "(Ljava/lang/String;)V",
    "setGender" => "(I)V",
    "setBirthYear" => "(I)V",
    "addDesignEventWithEventId" => "(Ljava/lang/String;)V",
    "addDesignEventWithAmount" => "(Ljava/lang/String;F)V",
    "addBusinessEvent" => "(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
    "addResourceEvent" => "(ILjava/lang/String;FLjava/lang/String;Ljava/lang/String;)V",
    "addProgressionEvent" => "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V",
    "addErrorEvent" => "(ILjava/lang/String;)V",
    "configureSdkGameEngineVersion" => "(Ljava/lang/String;)V",
    "configureGameEngineVersion" => "(Ljava/lang/String;)V",
    "setEnabledManualSessionHandling" => "(Z)V",
    "startSession" => "()V",
    "endSession" => "()V",
    "isCommandCenterReady" => "()Z",
    "getCommandCenterValueAsString" => "(Ljava/lang/String;)Ljava/lang/String;",
    "getCommandCenterValueAsStringWithDefVal" => "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;"
  ];
  #end
}

;
!(function (window) {
  'use strict';

  var _jsAsynCall = window.external && window.external.jsAsynCall;
  var _cefQuery = window.cefQuery;
  var _isWpsEnv = _jsAsynCall || _cefQuery;
  var jsAsynCallCallbackCount = 0;

  /**
   * webJs 与 KsoApi 通信一级接口
   * @param  {String}   methodName    KsoApi方法名
   * @param  {[JSON]}   [args]        KsoApi方法约定数据格式JSON
   * @param  {[Function]} [callback]  KsoApi执行回调
   * @return {[type]}                 undefined
   */
  var jsAsynCall = function (methodName, args, callback) {
    var callbackName = methodName + '_async_callback_' + ++jsAsynCallCallbackCount;

    hookArgsFunction(args);

    var invokeParams = {
      method: methodName,
      params: args,
      callback: callbackName
    };

    window[callbackName] = function (res) {
      delete window[callbackName];
      callback instanceof Function && callback(JSON.parse(window.Base64.decode(res)));
    };

    var jsonIn = window.Base64.encode(JSON.stringify(invokeParams));
    if (_cefQuery) {
      _cefQuery({
        request: 'jsAsynCall("' + jsonIn + '")',
        persistent: false
      });
    } else {
      _jsAsynCall(jsonIn);
    }
  }

  var dispatchCallback = function(params) {
    params = JSON.parse(window.Base64.decode(params));
    console.log(params)
    var id = params.id;
    var methodName = 'dispatchCallback' + '_' + id;
    window[methodName](params.res);
    delete window[methodName];
  }

  function hookArgsFunction(args) {
    for(var key in args) {
      var val = args[key];
      if (typeof val === 'function') {
        var func = args[key];
        var methodName;
        var id;

        do{
          id = guid('_');
          methodName = 'dispatchCallback' + '_' + id;
        }while(window[methodName] != undefined);

        args[key] = {
          guid: id,
          funcName: 'dispatchCallback'
        }

        window[methodName] = func;
      }else if (typeof val === 'object'){
        hookArgsFunction(val);
      }
    }
  }

  var guid = function(split) {
    function s4() {
      return Math.floor((1 + Math.random()) * 0x10000)
        .toString(16)
        .substring(1);
    }
    return s4() + s4() + split + s4() + split + s4() + split + s4() + split + s4() + s4() + s4();
  }

  window.dispatchCallback = dispatchCallback;
  window.guid = guid;
  window.ksoJsAsynCall = jsAsynCall;

}(window));
;
!(function (window, document) {
  'use strict';

  // 对应 main.rb 中的ApiObject 属性方法
  // 调起浏览器窗口
  document.querySelector('#openWord').addEventListener('click', function (e) {

    window.ksoJsAsynCall('openWord', {
      filepath: getFilepath()
    }, function (res) {
      console.log(res);
      document.querySelector('#methodCallback').innerHTML = '"openWord" result:' + res.result + ' of  ksoJsAsynCall is done!'
    });

  });

  document.querySelector('#addWord').addEventListener('click', function (e) {

    window.ksoJsAsynCall('openWordTemp', {
      filepath: getFilepath()
    }, function (res) {
      console.log(res);
      document.querySelector('#methodCallback').innerHTML = '"openWordTemp" result:' + res.result + ' of  ksoJsAsynCall is done!'
    });

  });

  document.querySelector('#getActiveWorkbookName').addEventListener('click', function (e) {

    window.ksoJsAsynCall('getActiveWorkbookName', {
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"getActiveWorkbookName" result:' + res.result + ' of  ksoJsAsynCall is done!'
      })
  });

  document.querySelector('#openExcel').addEventListener('click', function (e) {

    window.ksoJsAsynCall('openExcel', {
      filepath: getFilepath()
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"openExcel" of  ksoJsAsynCall is done!'
    })
  });

  document.querySelector('#addExcel').addEventListener('click', function (e) {

    window.ksoJsAsynCall('openExcelTemp', {
      filepath: getFilepath()
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"openExcelTemp" of  ksoJsAsynCall is done!'
    })
  });

  document.querySelector('#login').addEventListener('click', function (e) {

    window.ksoJsAsynCall('login', {
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"login" of  ksoJsAsynCall is done!'
    })
  });

  document.querySelector('#test').addEventListener('click', function (e) {
    var name = getFilepath()
    window.ksoJsAsynCall('connectSelectionChange', {
      context: name
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"connectSelectionChange" result:' + res.result
    })
  });

  document.querySelector('#disconnect').addEventListener('click', function (e) {
    var name = getFilepath()
    window.ksoJsAsynCall('disConnectSelectionChange', {
      context: name
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"disConnectSelectionChange" result:' + res.result
    })
  });

  document.querySelector('#dbCreatUniqueFileId').addEventListener('click', function (e) {

    window.ksoJsAsynCall('dbCreatUniqueFileId', {
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"test" result:' + res.result
    })
  });

  document.querySelector('#dbPostData').addEventListener('click', function (e) {
    var val = JSON.parse(getFilepath())
    console.log(val)
    window.ksoJsAsynCall('dbPostData', {
      file_id: '8e2af4a039bed6139eb36afcf25c79aa', table: 'test_table', key: 'data', value: val
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"test" result:' + res.result
    })
  });

  document.querySelector('#dbGetData').addEventListener('click', function (e) {
    window.ksoJsAsynCall('dbGetData', {
      file_id: '8e2af4a039bed6139eb36afcf25c79aa', table: 'test_table'
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"test" result:' + res.result
    })
  });

  document.querySelector('#callbackToJs').addEventListener('click', function (e) {

     window.ksoJsAsynCall('callback', {
       methodName: 'callJs'
     }, function (res) {
     });
  });

  document.querySelector('#download').addEventListener('click', function (e) {

      window.ksoJsAsynCall('downLoadFile', {
          url:getFilepath()
      }, function (res) {
          confirm(res.result)
      })
  });

  document.querySelector('#showPayDlg').addEventListener('click', function (e) {

    window.ksoJsAsynCall('showPayDlg', {
      url: getFilepath()
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"showPayDlg" of  ksoJsAsynCall is done!'
    })    
  });

  document.querySelector('#selectCell').addEventListener('click', function (e) {

    window.ksoJsAsynCall('selectCell', {
      range: getFilepath()
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"selectCell" of  ksoJsAsynCall is done!'
    })    
  });

  document.querySelector('#getValue').addEventListener('click', function (e) {

    window.ksoJsAsynCall('getSheetValue', {
      range: getFilepath()
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"getSheetValue' + res.result + '" of  ksoJsAsynCall is done!'
    })    
  });

  document.querySelector('#getSheetSelection').addEventListener('click', function (e) {

    window.ksoJsAsynCall('getSelection', {}, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"getSelection" ' + res.result + ' of  ksoJsAsynCall is done!'
    })    
  });
  document.querySelector('#cellChange').addEventListener('click', function (e) {

    window.ksoJsAsynCall('connectCellChange', {
      context: getFilepath()
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"cellChange" of  ksoJsAsynCall is done!'
    })    
  });

  document.querySelector('#insertRow').addEventListener('click', function (e) {

    window.ksoJsAsynCall('insertRow', {
      row: getFilepath()
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"insertRow" of  ksoJsAsynCall is done!'
    })    
  });

  document.querySelector('#editValue').addEventListener('click', function (e) {
    var arr = getFilepath().split(',');
    window.ksoJsAsynCall('setSheetValue', {
      range: arr[0],
      value: arr[1]
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"setSheetValue" of  ksoJsAsynCall is done!'
    })    
  });

  document.querySelector('#save').addEventListener('click', function (e) {

    window.ksoJsAsynCall('saveExcel', {}, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"saveExcel" of  ksoJsAsynCall is done!'
    })    
  });

  document.querySelector('#addSheet').addEventListener('click', function (e) {

    window.ksoJsAsynCall('addSheet', {}, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"addSheet" ' + res.result + ' of  ksoJsAsynCall is done!'
    })    
  });

  document.querySelector('#pickFile').addEventListener('click', function (e) {

    window.ksoJsAsynCall('openFileDialog', {
      title: '选择文件',
      path: 'D:',
      desc: '任意文件',
      suffix: '*.*'
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"openFileDialog" of  ksoJsAsynCall is done!'
        document.querySelector('#path').value = res.result
    })    
  });

  document.querySelector('#hideSheet').addEventListener('click', function (e) {

    window.ksoJsAsynCall('hideSheet', {
      name: getFilepath()
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"hideSheet" ' + res.result + ' of  ksoJsAsynCall is done!'
    })    
  });

  document.querySelector('#connectSheetActive').addEventListener('click', function (e) {
    window.ksoJsAsynCall('connectSheetActivate', {}, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"connectSheetActivate" ' + res.result + ' of  ksoJsAsynCall is done!'
    })    
  });

  document.querySelector('#connectWorkbookActive').addEventListener('click', function (e) {
    window.ksoJsAsynCall('connectWorkbookActivate', {}, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"connectWorkbookActivate" ' + res.result + ' of  ksoJsAsynCall is done!'
    })
  });

  document.querySelector('#connectWorkbookClose').addEventListener('click', function (e) {
    window.ksoJsAsynCall('connectWorkbookClose', {}, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"connectWorkbookClose" ' + res.result + ' of  ksoJsAsynCall is done!'
    })
  });

  document.querySelector('#showInputBox').addEventListener('click', function (e) {
    window.ksoJsAsynCall('showInputBox', {
      prompt: '请输入标题区域',
      title: '请选择单元格'
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"showInputBox" ' + res.result + ' of  ksoJsAsynCall is done!'
    })
  });

  document.querySelector('#excelSaveAs').addEventListener('click', function (e) {
    window.ksoJsAsynCall('excelSaveAs', {}, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"excelSaveAs" ' + res.result + ' of  ksoJsAsynCall is done!'
    })
  });

  document.querySelector('#closeWorkbook').addEventListener('click', function (e) {
    window.ksoJsAsynCall('closeActiveWorkbook', {}, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"closeActiveWorkbook" ' + res.result + ' of  ksoJsAsynCall is done!'
    })
  });

  document.querySelector('#getUsedRange').addEventListener('click', function (e) {
    window.ksoJsAsynCall('getUsedRangeAddress', {}, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"getUsedRangeAddress" ' + res.result + ' of  ksoJsAsynCall is done!'
    })

  });

  document.querySelector('#showMessageBox').addEventListener('click', function (e) {
    window.ksoJsAsynCall('showMessageBox', {}, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"showMessageBox" ' + res.result + ' of  ksoJsAsynCall is done!'
    })
  });
  
  document.querySelector('#setValidationArray').addEventListener('click', function (e) {
    var pars = getFilepath().split(',');
    var arr = ""
    for(var i = 1; i < pars.length; i++){
      if(i>1) {
        arr += ',';
      }
      arr += pars[i];
    }
    window.ksoJsAsynCall('setRangeInCellDropdownValidation', {
      address: pars[0],
      array: arr
    }, function (res) {
      console.log(res);
      document.querySelector('#methodCallback').innerHTML = '"setRangeInCellDropdownValidation" ' + res.result + ' of  ksoJsAsynCall is done!'
    })
  });
  
  document.querySelector('#setComment').addEventListener('click', function (e) {
    var arr = getFilepath().split(',')
    var addr = arr[0];
    var msg = arr[1];
    window.ksoJsAsynCall('setComment', {
      address: addr,
      comment: msg
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"setComment" ' + res.result + ' of  ksoJsAsynCall is done!'
    })
  });
  
  document.querySelector('#getCustomProperty').addEventListener('click', function (e) {
    window.ksoJsAsynCall('getCustomDocumentProperty', {
      name: getFilepath()
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"getCustomDocumentProperty" ' + res.result + ' of  ksoJsAsynCall is done!'
    })
  });

  document.querySelector('#setCustomProperty').addEventListener('click', function (e) {
    window.ksoJsAsynCall('setCustomDocumentProperty', {
      name: getFilepath().split(',')[0],
      value: getFilepath().split(',')[1]
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"getCustomDocumentProperty" ' + res.result + ' of  ksoJsAsynCall is done!'
    })
  });

  document.querySelector('#getUserInfo').addEventListener('click', function (e) {
    window.ksoJsAsynCall('getUserInfo', {
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"getUserInfo" ' + res.result + ' of  ksoJsAsynCall is done!'
    })
  });

  document.querySelector('#dbPostCommData').addEventListener('click', function (e) {
    var arr = getFilepath().split(',')
    window.ksoJsAsynCall('dbPostCommonData', {
      table: arr[0],
      key: arr[1],
      value: arr[2],
      context:arr[3]
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"dbPostCommonData" ' + res.result + ' of  ksoJsAsynCall is done!'
    })
  });

  document.querySelector('#dbGetCommData').addEventListener('click', function (e) {
    window.ksoJsAsynCall('dbGetCommonData', {
      table: getFilepath().split(',')[0],
      context: getFilepath().split(',')[1]
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"dbGetCommonData" ' + res.result + ' of  ksoJsAsynCall is done!'
    })
  });

  document.querySelector('#uplpoadFile').addEventListener('click', function (e) {
    window.ksoJsAsynCall('upLoadFile', {
      locate_file: getFilepath()
    }, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"upLoadFile" ' + res.result + ' of  ksoJsAsynCall is done!'
    })
  });

  document.querySelector('#getDir').addEventListener('click', function (e) {
    window.ksoJsAsynCall('getStorageDir', {}, function (res) {
        console.log(res);
        document.querySelector('#methodCallback').innerHTML = '"getStorageDir" ' + res.result + ' of  ksoJsAsynCall is done!'
    })
  });

  window.onServiceFinished = function(res) {
    res = window.Base64.decode(res)
    console.log(res)
  }

  window.callJs = function (res) {
      confirm(window.Base64.decode(res))
  };

  window.userStateChanged = function (res) {
      // confirm(window.Base64.decode(res))
  };

  window.onSheetSelectionChange = function (res) {
    res = window.Base64.decode(res)
    document.querySelector('#changeMsg').innerHTML = res
  };

  window.onCellChange = function (res) {
    res = window.Base64.decode(res)
    console.log(res)
    var cell = JSON.parse(res)
    document.querySelector('#changeMsg').innerHTML = "单元格位置：" + cell.address + ",内容：" + cell.value
  }

  window.onSheetChange = function(res) {
    res = window.Base64.decode(res)
    console.log(res)
  }

/*window.ksoJsAsynCall('registerUserChanged', {
      callbackName : 'logUserChanged'
  }, function (res) {
  });*/

  window.logUserChanged = function (res) {
    confirm(window.Base64.decode(res));
  };

  window.onWorkbookClose = function(res) {
    console.log(window.Base64.decode(res))
  }

  window.onWorkbookActivate = function(res) {
    console.log(window.Base64.decode(res))
  }

  window.onSheetActivate = function(res) {
    console.log(window.Base64.decode(res))
  }

  window.onNewSelection = function(res) {
    res = window.Base64.decode(res)
    document.querySelector('#changeMsg').innerHTML = "onNewSelection:" + res
  }

  function getFilepath() {
      var path = document.querySelector('#path').value;
      console.log(path);
      return path;
  }

  window.onFileUploadStarting = function(res) {
    res = window.Base64.decode(res)
    document.querySelector('#changeMsg').innerHTML = "onFileUploadStarting:" + res
  }

  window.onUploadFileSucceeded = function(res) {
    res = window.Base64.decode(res)
    document.querySelector('#changeMsg').innerHTML = "uploadFileSucceeded:" + res
  }

  window.onUploadFileFailed = function(res) {
    res = window.Base64.decode(res)
    document.querySelector('#changeMsg').innerHTML = "onUploadFileFailed:" + res
  }

}(window, document));
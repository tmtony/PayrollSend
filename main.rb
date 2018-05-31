=begin
** Created: 2017/12/23
**      by: 金山软件--tmtony(王宇虹)
** Modified: 2018/01/18
**      by: 金山软件--tmtony(王宇虹)
**
** Description:插件主入口
=end

$LOAD_PATH << "#{__dir__}/lib"
require 'sdk'
require 'Qt'
require_relative 'src/apis'
require_relative 'src/widget'
 
require_relative 'src/apiobjecthelper.rb'
require_relative 'src/officeapi.rb'

 
module SalaryMailPlugin

   class MainFrame < KSO_SDK::View::Frame

    define_button :webview
    define_button :widget

    attr_accessor :web
  
    def initialize(context, app)
      super(nil)
      @app = app
      @context = context
      webview.setText('WebView')
      widget.setText('Widget')
      self.layout = Qt::HBoxLayout.new do |l|
        l.addWidget(webview)
        l.addWidget(widget)
      end
      webview.onClicked = :showWebView
      widget.onClicked = :showWidgets
    end
  
    def showWidgets()
      @app.setContentWidget(DemoFrame.new())
    end
  
    def showWebView()
      self.web = KSO_SDK::View::WebViewWidget.new(@context) #new(@context, true, false)
      web.showUrl(__dir__ + '\web\index.html')
      web.registerJsApi(Sample.new())
      @app.setContentWidget(web)
    end
  end
  
  
  class MainApp < KSO_SDK::App
    attr_accessor :startshow

    def onCreate(context)
      #setContentWidget(MainFrame.new(context, self)) #设置任务窗格显示的控件    
      puts "start1" 

      # puts KSO_SDK.getCloudService().getUserInfo().userName
      # puts KSO_SDK.getCloudService().getUserInfo().sessionId
      # puts KSO_SDK.getCloudService().getUserInfo().userId
      web = KSO_SDK::View::WebViewWidget.new(context)
      web.showUrl(__dir__ + '\web\index.html')
      jsApi = Sample.new()
      web.registerJsApi(jsApi)
      setContentWidget(web) 


      currSubWindow = KxWebViewWidget.getCurrentSubWindow
      currSubWindow.setProperty("SalaryMail_loadedrubyscript", Qt::Variant::fromValue(true))

      #问题1 ，$apiObjectHelper 在apis.rb中的 boardcastCustomMessage 事件中用到
      $apiObjectHelper ||= ApiObjectHelper.new
      $apiObjectHelper.addApi(jsApi)

      puts $apiObjectHelper
      #问题2 Office事件处理，主要处理工作簿和工作表的事件，用SDK后应该如何处理，要传递一个jsApi参数？
      @officeApi ||= OfficeApi.new(web, jsApi, self)  #@jsObj


      #问题3 以前是插件已经打开过，切换工作簿时 要执行onWindowActivate事件，以便提取工作簿的邮件配置
      # if @run.nil?

      #   @run ||= true
 
      # else
      #   $mainctrl.officeApi.onWindowActivate
      # end
      userid=KSO_SDK.getCloudService().getUserInfo().userId

      if userid.nil?
          puts '没有登录'
          btnMask = Qt::MessageBox::information(KSO_SDK.getCurrentMainWindow(), '登录', '使用助手需要先登录WPS！请先登录！', Qt::MessageBox::Yes, Qt::MessageBox::Yes)
      else
          puts '登录成功'
          puts userid
          puts KSO_SDK.getCloudService().getUserInfo().userName
      end  

    end

  end
  
  KSO_SDK.start(dir:__dir__, page: MainApp) #启动插件
end
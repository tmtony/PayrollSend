=begin
** Created: 2017/12/23
**      by: 金山软件--tmtony(王宇虹)
** Modified: 2018/01/18
**      by: 金山软件--tmtony(王宇虹)
**
** Description:插件主入口
=end

$LOAD_PATH << "#{File.dirname(__FILE__)}/lib"
require 'sdk'
require 'Qt'
require_relative 'src/apis'
 
require_relative 'src/apiobjecthelper.rb'
require_relative 'src/officeapi.rb'

 
module SalaryMailPlugin

  class MainApp < KSO_SDK::App
  
    def onCreate(context)
      if @web.nil?
        @web = KSO_SDK::View::WebViewWidget.new(context)
        @web.showUrl(File.dirname(__FILE__) + '\web\index.html')
        @web.registerJsApi(Sample.new())
      end
      setContentWidget(@web)
    end

  end
  
  KSO_SDK.start(dir:File.dirname(__FILE__), page: MainApp)
end
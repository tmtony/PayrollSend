=begin
** Created: 2017/12/23
**      by: 金山软件--tmtony(王宇虹)
** Modified: 2018/01/18
**      by: 金山软件--tmtony(王宇虹)
**
** Description:与Office交互的接口
=end

require 'win32ole'
require 'sdk'
 

module SalaryMailPlugin
  class OfficeApi

    def initialize(web, jsObj,mainapp)
      puts ("officeApi-Start")
      @webWidget = web
      @jsObj = jsObj
      @mainapp=mainapp
      if @apiApp.nil?
        @apiApp = KSO_SDK::Application #WIN32OLE::setdispatch(KxWin32ole::getDispatch)
        if !@jsObj.nil? && !web.nil?
          @winAct = KSO_SDK::Event.new(eventTarget: @apiApp, eventName: 'WindowActivate') #WIN32OLE_EVENT.new(@apiApp, 'AppEvents')
          @shAct = KSO_SDK::Event.new(eventTarget: @apiApp, eventName: 'SheetActivate')
          # @ev.on_event('SlideSelectionChanged') {|sldRange| onSlideSelectionChanged(sldRange)}
          # @ev.on_event('PresentationCloseFinal') {|pres| onPresentationClose(pres)}
          @winAct.connect do #@ev.on_event('WindowActivate') {onWindowActivate()}
            onWindowActivate()
          end
         # @ev.on_event('Open') {onOpen()}
          #@ev.on_event('SheetActivate') {|sh| onSheetActivate(sh)}
          @shAct.connect do |sh|
            onSheetActivate(sh)
          end

        end
      end
      puts ("officeApi-End")
    end
 
    def onWindowActivate()
 

      puts ("onWindowActivate")
      # getCurrentSubWindow方法的第一个版本有问题，在没有文档的情况下调用会异常，所以暂时加上noDoc判断一下
      begin
        widget = @noDoc == true ? nil : KxWebViewWidget.getCurrentSubWindow
        @noDoc = false
        if !widget.nil?
          isRubyWnd = widget.property("SalaryMail_loadedrubyscript")
          # 由于active会比main的入口还要早，所以这里只处理已经打开过的窗口，初次打开的由main入口去处理
          if !isRubyWnd.isNull
            showpane = widget.property("SalaryMail_loadedrubyscript")
            startshow = @mainapp.startshow
            show = true

            if showpane.isNull
              show = startshow
            else
              show = showpane.toBool
            end
            puts 'show'
            puts show
            @mainapp.setVisible(show)
           # $mainctrl.taskpane.setVisible(show) unless $mainctrl.taskpane.nil?
            widget.setProperty("SalaryMail_loadedrubyscript", Qt::Variant::fromValue(show))
          else
            @mainapp.setVisible(false) #unless $mainctrl.taskpane.nil?
          end
        end
        #$activeWorkbook = $apiApp.ActiveWorkbook #重新设置新的激活工作簿
 
        @jsObj.onWorkbookChanged() #if entryid != ""
 
      rescue
        p $!
      end
      puts ("onWindowActivate-End")

    end

    def onSheetActivate(sh)
        p 'onSheetActivate'
        #p $apiApp.ActiveWorkbook.name

        if !KSO_SDK::Application.ActiveWorkbook.Sheets.nil?
          KSO_SDK::Application.ActiveWorkbook.Sheets.each do |sheet|

            sheetName =sheet.name
            #currSheetName=$apiApp.ActiveWorkbook.Activesheet.name
            if sheetName.include?('发送日志_') && sheetName!=sh.name
               sheet.visible=2
            end
          end
        end
    end 
 
    def getCaption
      return KSO_SDK::Application.Caption
    end
  end
end
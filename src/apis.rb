=begin
** Created: 2017/12/23
**      by: 金山软件--tmtony(王宇虹)
** Modified: 2018/06/06
**      by: 金山软件--tmtony(王宇虹)
**
** Description:API接口
=end

require 'sdk'
require 'json'
require 'Qt'
require 'net/smtp'
require_relative 'kssmtp.rb'
require_relative 'apiobjecthelper.rb'
require_relative 'kpluginsettings.rb'
require_relative 'smtp.rb'

include Mail

module SalaryMailPlugin

  class Sample < KSO_SDK::JsBridge

    public

     

    # 使用cef，注意，使用cef必须在cefplugin ready为前提，关注kxcefpluginstate
    KXWEBVIEW_IMPL_TYPE_CEF = 0

    Window = 0x00000001
    Dialog = 0x00000002 | Window

    def navigateOnNewWidget(url,bModal,width,height,closeBtn)
      result={}
      begin
         
        puts ("navigateOnNewWidget-Start:"+url)
        if !KSO_SDK::Application.ActiveSheet.nil?
          if KSO_SDK::Application.ActiveSheet.name.include?('发送日志_') #Activate the first sheet
            KSO_SDK::Application.ActiveWorkbook.Sheets(1).Activate
          end
        end

 
        if !url.nil?
          # @web_view = KxWebViewWidget.new($kxApp.currentMainWindow, KXWEBVIEW_IMPL_TYPE_CEF)
          @web_view = ShadowWebViewDialog.new(self.context) # KSO_SDK::View::WebViewWidget.new ShadowWebView.new(KxWebViewWidget.getCurrentSubWindow, KXWEBVIEW_IMPL_TYPE_CEF)


          newwidth = getWidth(width)
          newheight = getHeight(height)
 
          parentWindow =$kxApp::desktop() # KxWebViewWidget.getCurrentSubWindow

          left = ($kxApp.currentMainWindow.width - newwidth) / 2
          top = ($kxApp.currentMainWindow.height - newheight) / 2

          left=10 if left<0
          top=10 if top<0

          # left = (parentWindow.width - width) / 2
          # top = (parentWindow.height - height) / 2
          # end


          @web_view.setGeometry(left, top, newwidth, newheight)

          @web_view.setAttribute(Qt::WA_DeleteOnClose, true);
          # @web_view.setWindowFlags(Qt::FramelessWindowHint | Qt::MSWindowsFixedSizeDialogHint)


          #@web_view.setAttribute(Qt::WA_DeleteOnClose, false);
          if bModal
            @web_view.setAttribute(Qt::WA_ShowModal, true)
          end

          @web_view.setWindowFlags(Dialog | Qt::Window | Qt::FramelessWindowHint) #Dialog | Qt::Window | Qt::WA_TranslucentBackground

          @js_obj = Sample.new()
          # @js_obj.setObjectName('dialog')
          # self.setObjectName('main')
          @js_obj.web_view = @web_view
          broadcast = KSO_SDK::Broadcast.new()
          broadcast.register 'notify' do 
            puts 'notify'
            callbackToJS('onRefresh', {:url=>'https://www.baidu.com'}.to_json)
          end
          @js_obj.broadcast = broadcast
          # connect(@js_obj, SIGNAL('notifyToWidgetEvent(const QString&)'),
          #         self, SLOT('onNotifyToWidget(const QString&)'))


          @web_view.showUrl(url)
          @web_view.registerJsApi(@js_obj)
          @web_view.show()
          #setContentWidget(web)

          # @web_view.showWebView(url, @js_obj)
          #@web_view.setVisible(true)

          result['result']="ok"
          result['msg']="打开弹窗成功"
        end
      rescue Exception => e
        result['result']="error"
        result['msg']="打开弹窗出错"
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure
        return result.to_json
        #setResult(context, Qt::Variant.new(result.to_json))
        puts (result.to_json)

        puts ("navigateOnNewWidget-End:")
      end


    end

    def broadcast=(broadcast)
      @broadcast = broadcast
    end

    def web_view=(view)
      @webWidget = view

    end
 
     def setDragRect(x,y,width,height)
      if !@webWidget.nil?
        @webWidget.onSetDragArea(Qt::Rect.new(x, y, width, height))
      end  
      p 'setDragRect End'
    end

    def getAppInfoJs()

    end
    
    def showBrowser(url)
      require 'win32ole' 
      shell = WIN32OLE.new('Shell.Application')
      shell.ShellExecute(url, '', '', 'open', 1)
      shell = nil
    end

    def boardcastCustomMessage(msgProc,msgProcArgs)
      puts 'boardcastCustomMessage'
      # 窗口广播通信接口, c++ 已有实现
      # map = parseContextArgs(context)
      # func = map["msgProc"]
      # para = map["msgProcArgs"]
      $apiObjectHelper.boardcastCustomMessage(msgProc, msgProcArgs)
      puts 'boardcastCustomMessage-end'
    end



  
    def loadNameAndEmailCfg()
      puts (__method__.to_s)
      begin
        param={}
        param['namerange']=""
        param['emailrange']=""

        sheet=AddWorkSheet('KSO_Salary_Config',false,false)
        if !sheet.nil?
          param['namerange']=sheet.Cells(15, 2).value
          param['emailrange']=sheet.Cells(16, 2).value
        end
      rescue Exception => e
        param['namerange']=""
        param['emailrange']=""
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure
        puts (param.to_json) 
        return param.to_json
        
      end

    end


    def saveNameAndEmailCfg(namerange,emailrange)
          puts (__method__.to_s)
           
          begin
     
            result={}
  
            salarySheet=KSO_SDK::Application.ActiveWorkbook.Activesheet  
            rng=salarySheet.range(namerange)
            if rng!=false 
                  startRow=0
                  nameCol=0
                  nameCol=rng.column
                  rng2=rng.offset(1,0) 
                  namestartRow=rng2.row
                  
            end   
            rng=salarySheet.range(emailrange)
            if rng!=false 
                  startRow=0
                  emailCol=0
                  emailCol=rng.column
                  rng2=rng.offset(1,0) 
                  emailstartrow=rng2.row     
            end  

            if namestartRow==emailstartrow then  
                sheet=AddWorkSheet('KSO_Salary_Config',false,true)
                if !sheet.nil?
          
                  sheet.Cells(15, 1).value='姓名数据单元格'
                  sheet.Cells(15, 2).value=namerange
                   
                  sheet.Cells(16, 1).value='邮箱数据单元格'
                  sheet.Cells(16, 2).value=emailrange

                  

                end
                result['result']="ok"
                result['msg']="保存姓名邮箱单元格成功"
            else
                result['result']="error"
                result['msg']="姓名与邮箱起始行不一致"
            end 

            

          rescue Exception => e
            result['result']="error"
            result['msg']="保存姓名邮箱单元格出错"
            puts ("出错信息:"+e.message)
            puts ("出错位置:"+e.backtrace.inspect)
          ensure
            puts result.to_json
            return result.to_json
          end
     
    end


    def getNamePos()
          puts (__method__.to_s)
           
          begin
     
            result={}
            rng=GetRange()
            salarySheet=KSO_SDK::Application.ActiveWorkbook.Activesheet #.Sheets(1)
            if rng!=false
                result['namerange']="" #姓名位置
                sheet=AddWorkSheet('KSO_Salary_Config',false,true)
                if !sheet.nil?         
                  p rng.address            
                  #sheet.Cells(8, 1).value='数据开始行'
                  #sheet.Cells(8, 2).value=rng.Column.to_s
                  sheet.Cells(10, 1).value='姓名列'
                  sheet.Cells(10, 2).value=rng.Column.to_s
                  #sheet.Cells(10, 3).value=nameText
                  #sheet.Cells(10, 4).value=rowHeader.to_s
                end
                startRow=0
                nameCol=0
                nameCol=rng.column
                rng2=rng.offset(1,0) 
                startRow=rng2.row
                

                if startRow>0 && nameCol>0
                   endRow=salarySheet.Cells(20000, nameCol).End(-4162).Row #dataEndRow=sheet.Cells(65536, nameCol).End(3).Row
                   endRow=10000 if endRow>10000  
                   result['startrow']=startRow
                   result['namecnt']=endRow-startRow+1
                end    
                result['namerange']=rng.address.to_s.gsub("$","")  
              

                result['result']="ok"
                result['msg']="选择姓名成功"
            else
                result['result']="error"
                result['msg']="请选择有效的区域"
            end      
          rescue Exception => e
            result['result']="error"
            result['msg']="选择姓名出错"
            puts ("出错信息:"+e.message)
            puts ("出错位置:"+e.backtrace.inspect)
          ensure
            puts result.to_json
            return result.to_json
          end
     
    end


    def getEmailPos()
          puts (__method__.to_s)
           
          begin
     
            result={}
            
            rng=GetRange()
            salarySheet=KSO_SDK::Application.ActiveWorkbook.Activesheet #.Sheets(1)
            if rng!=false
                  result['emailrange']=""

                  sheet=AddWorkSheet('KSO_Salary_Config',false,true)
                  if !sheet.nil?
           
                    p rng.address
                    
                    #sheet.Cells(8, 1).value='数据开始行'
                    #sheet.Cells(8, 2).value=rng.Column.to_s
                    sheet.Cells(11, 1).value='邮箱列'
                    sheet.Cells(11, 2).value=rng.Column.to_s
                    #sheet.Cells(11, 3).value=nameText
                    #sheet.Cells(11, 4).value=rowHeader.to_s

                  end
                  startRow=0
                  emailCol=0
                  emailCol=rng.column
                  rng2=rng.offset(1,0) 
                  startRow=rng2.row
                  

                  if startRow>0 && emailCol>0
                     endRow=salarySheet.Cells(20000, emailCol).End(-4162).Row #dataEndRow=sheet.Cells(65536, nameCol).End(3).Row
                     endRow=10000 if endRow>10000  
                     result['startrow']=startRow
                     result['emailcnt']=endRow-startRow+1
                  end    

                  result['emailrange']=rng.address.to_s.gsub("$","")  
              

                  result['result']="ok"
                  result['msg']="选择邮箱成功"
              else
                  result['result']="error"
                  result['msg']="请选择有效的区域"
              end      
          rescue Exception => e
            result['result']="error"
            result['msg']="选择邮箱出错"
            puts ("出错信息:"+e.message)
            puts ("出错位置:"+e.backtrace.inspect)
          ensure
            puts result.to_json
            return result.to_json
          end
      
    end


    def refreshRecord(namerange,emailrange) 
          puts (__method__.to_s)
           
          begin
     
            result={}
            # namerange='$A$1'
            # emailrange='$C$1'
            salarySheet=KSO_SDK::Application.ActiveWorkbook.Activesheet
            rng=salarySheet.range(namerange)
            if rng!=false 
                  startRow=0
                  nameCol=0
                  nameCol=rng.column
                  rng2=rng.offset(1,0) 
                  startRow=rng2.row
                  

                  if startRow>0 && nameCol>0
                     endRow=salarySheet.Cells(20000, nameCol).End(-4162).Row  
                     endRow=10000 if endRow>10000  
                     namestartrow=startRow
                     namecnt=endRow-startRow+1
                  end    
            end   
            rng=salarySheet.range(emailrange)
            if rng!=false 
                  startRow=0
                  emailCol=0
                  emailCol=rng.column
                  rng2=rng.offset(1,0) 
                  startRow=rng2.row
                  

                  if startRow>0 && emailCol>0
                     endRow=salarySheet.Cells(20000, emailCol).End(-4162).Row #dataEndRow=sheet.Cells(65536, nameCol).End(3).Row
                     endRow=10000 if endRow>10000  
                     emailstartrow=startRow
                     emailcnt=endRow-startRow+1
                  end    
            end    
            if namestartrow==emailstartrow then
                result['emailcnt']=emailcnt #邮箱数  暂时固定返回值，等前端做好后联合测试
                result['namecnt']=namecnt  #人员数 
               

                result['result']="ok"
                result['msg']="刷新数据成功"
            else
                result['emailcnt']=emailcnt #邮箱数  暂时固定返回值，等前端做好后联合测试
                result['namecnt']=namecnt  #人员数 
               

                result['result']="error"
                result['msg']="姓名开始行与邮箱开始行不一致"
            end  

            

          rescue Exception => e
            result['result']="error"
            result['msg']="刷新数据出错"
            puts ("出错信息:"+e.message)
            puts ("出错位置:"+e.backtrace.inspect)
          ensure
            puts result.to_json
            return result.to_json
          end
      
    end


    #自动检测姓名与邮箱
    def autoDetectField()
          puts (__method__.to_s)
           
          begin
     
            result={}
            
            sheetSalary=KSO_SDK::Application.ActiveWorkbook.Activesheet
            rng=sheetSalary.cells.Find(:what => "邮箱") # or :what=>"邮箱"
            if rng.nil?
              rng=sheetSalary.cells.Find(:what => "邮 箱") # or :what=>"邮箱"
            end
            if rng.nil?
              rng=sheetSalary.cells.Find(:what => "email") # or :what=>"邮箱"
            end

            if rng.nil?
              rng=sheetSalary.cells.Find(:what => "e-mail") # or :what=>"邮箱"
            end


            if rng.nil?
              rng=sheetSalary.cells.Find(:what => "mail") # or :what=>"邮箱"
            end

            if rng.nil?
              rng=sheetSalary.cells.Find(:what => "邮件") # or :what=>"邮箱"
            end

            if rng.nil?
              p 'Can\'t find email column'
            else
              result['emailrange']=rng.address.to_s  #rng.offset(1,0).address.to_s 
              startRow=0
              emailCol=0
              emailCol=rng.column
              rng2=rng.offset(1,0) 
              startRow=rng2.row
              

              if startRow>0 && emailCol>0
                 endRow=salarySheet.Cells(20000, emailCol).End(-4162).Row  
                 endRow=10000 if endRow>10000  
                 result['startrow']=startRow
                 result['emailcnt']=endRow-startRow+1
              end   

            end 


            rng=sheetSalary.cells.Find(:what => "姓名") # or :what=>"邮箱"
            if rng.nil?
              rng=sheetSalary.cells.Find(:what => "姓 名") # or :what=>"邮箱"
            end
            if rng.nil?
              rng=sheetSalary.cells.Find(:what => "姓  名") # or :what=>"邮箱"
            end

           
            if rng.nil?
              p 'Can\'t find name column'
            else
              result['namerange']=rng.address.to_s  #rng.offset(1,0).address.to_s  

              startRow=0
              nameCol=0
              nameCol=rng.column
              rng2=rng.offset(1,0) 
              startRow=rng2.row
              

              if startRow>0 && nameCol>0
                 endRow=salarySheet.Cells(20000, nameCol).End(-4162).Row  
                 endRow=10000 if endRow>10000  
                 result['startrow']=startRow
                 result['namecnt']=endRow-startRow+1
              end    
 
            end 

 
            # result['namecnt']="10" #人员数  暂时固定返回值，等前端做好后联合测试
            # result['emailcnt']="10" #邮箱数  暂时固定返回值，等前端做好后联合测试
            # result['startrow']="10" #数据起始行

            result['result']="ok"
            result['msg']="自动检测姓名与邮箱成功"

          rescue Exception => e
            result['result']="error"
            result['msg']="自动检测姓名与邮箱出错"
            puts ("出错信息:"+e.message)
            puts ("出错位置:"+e.backtrace.inspect)
          ensure
            puts result.to_json
            return result.to_json
          end
    end

    def loadMailCfg()
      puts __method__.to_s
      begin
        param={}
        param['address']=""
        param['password']=""
        # param['emailtype']=""
        # param['provider']=""
 
        settings =KRubyAccountEmailSettings.new 
 
        param['address']=settings.getRegValue('address').toString
        param['password']=settings.getRegValue('password').toString 
 
        if param['address'].nil? or param['address']== ''  #如果没有，取旧版的配置 puts param['address'].empty? 出错

            sheet=AddWorkSheet('KSO_Salary_Config',false,false)
            if !sheet.nil?
              


              # param['emailtype']=sheet.Cells(5, 2).value
              # param['provider']=sheet.Cells(6, 2).value
              if sheet.Cells(1, 2).value != ''
                param['address']=sheet.Cells(1, 2).value 
                param['password']=sheet.Cells(2, 2).value
 
                settings.setRegValue('address', param['address'].to_s)
                settings.setRegValue('password', param['password'].to_s)
 
                sheet.Cells(1, 2).value=''
                sheet.Cells(2, 2).value=''
              end
            end
        end    
 

      rescue Exception => e
        param['address']=""
        param['password']=""
        # param['emailtype']=""
        # param['provider']=""
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure
        puts param.to_json 
        return param.to_json 
      end

    end

    def saveMailCfg(address,password)
      puts (__method__.to_s)
      begin
        result={}
 
        needCheck=false
 
 
        settings =KRubyAccountEmailSettings.new    
        settings.setRegValue('address', address)
        settings.setRegValue('password', password)
        
        # if sheet.Cells(1, 2).value != ''
        #   sheet.Cells(1, 2).value=''
        #   sheet.Cells(2, 2).value=''
        # end

        # sheet.Cells(5, 1).value="邮箱类型"
        # sheet.Cells(5, 2).value=emailtype

        # sheet.Cells(6, 1).value="提供商"
        # sheet.Cells(6, 2).value=provider

        result['result']="ok"
        result['msg']="邮件配置保存成功"
        checkSalaryItemRange(false) if needCheck #在第一次保存邮件配置时创建配置表并检查表头姓名列与邮件列
      rescue Exception => e
        result['result']="error"
        result['msg']="邮件配置保存出错"
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure
 
        puts (result.to_json)
        return result.to_json
      end

    end

    def loadSmtpCfg()
      puts (__method__.to_s)
      begin
        param={}
        param['smtpserver']=""
        param['port']=""


        settings =KRubyAccountEmailSettings.new  
        param['smtpserver']=settings.getRegValue('smtpserver').toString
        param['port']=settings.getRegValue('port').toString 
 
        if param['smtpserver'].nil? or param['smtpserver']== ''  #如果没有，取旧版的配置
           
          sheet=AddWorkSheet('KSO_Salary_Config',false,false)
          if !sheet.nil?
 
  


              if sheet.Cells(3, 2).value != ''
 
                param['smtpserver']=sheet.Cells(3, 2).value
                param['port']=sheet.Cells(4, 2).value

 
                settings.setRegValue('smtpserver', param['smtpserver'].to_s)
                settings.setRegValue('port', param['port'].to_s)                
 
                sheet.Cells(3, 2).value=''
                sheet.Cells(4, 2).value=''
              end              
 
          end
        end  

      rescue Exception => e
        param['smtpserver']=""
        param['port']=""
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure
        
        puts (param.to_json)
        return param.to_json
      end

    end

    
    def getBalance()
      puts (__method__.to_s)
      begin
        param={}
        param['balance']=""
 
        settings =KRubyAccountEmailSettings.new  
        param['balance']=settings.getRegValue('balance').toString     
 
        if param['balance'].nil? or param['balance']== '' 
          param['balance']="50"
          settings.setRegValue('balance', param['balance'].to_s)           
        end  
      rescue Exception => e
        param['balance']="0"
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure        
        puts (param.to_json)
        return param.to_json
      end
    end

    def sendTestMail(recipients)
      puts (__method__.to_s)
      result={}
      begin
 
        receiver=recipients
        subject="【工资条群发助手】您已登陆成功"  

        body = "您好! <br><br> 收到此邮件，说明您已经成功登陆工资条群发助手了；<br>在表格中填入收件人邮箱，并编辑好邮件模板就可以群发工资条了，快去试试吧！<br><br> " #body = "您好! <br><br> &nbsp;&nbsp;<b>邮件测试： #{subject}</b> <br><br> "

        settings =KRubyAccountEmailSettings.new  
        account=settings.getRegValue('address').toString
        pwd=settings.getRegValue('password').toString 
        host=settings.getRegValue('smtpserver').toString 
        port=settings.getRegValue('port').toString 

 
        if !host.nil?
 
          if !receiver.empty?

            if !host.nil?
                host=host.gsub("\n","") #替换掉特殊字符
                host=host.gsub(" ","") #替换掉空格
            end

            if !receiver.nil?
              receiver=receiver.gsub("\n","") #替换掉特殊字符
              receiver=receiver.gsub(" ","") #替换掉空格
            end

            mailContent=getMailContent(account, receiver, subject, body, [])

            if port=='465'
              isssl=true
            else
              isssl=false
            end 
 

             if port=='25'
                # if host !='smtp.wps.cn'
                  smtp = SMTP.new({:address => host,
                                     :port => port,
                                     :domain => 'localhost.localdomain',
                                     :user_name => account,
                                     :password => pwd,
                                     :open_timeout         => 8,
                                     :read_timeout         =>8,
                                     :openssl_verify_mode  => 'none'  #wps邮箱必须加这个
                                    }
                    )
                  smtp.deliver!(mailContent, account, receiver)
                # else

                # end
              else

                smtp = SMTP.new({:address => host,
                                   :port => port,
                                   :domain => 'localhost.localdomain',
                                   :user_name => account,
                                   :password => pwd,
                                   :ssl => isssl,
                                   :authentication       => 'login',
                                   :enable_starttls_auto => true,
                                   :open_timeout         => 8,
                                   :read_timeout         =>8,
                                   :openssl_verify_mode  => 'none'  #wps邮箱必须加这个
                                  }
                  )


                smtp.deliver!(mailContent, account, receiver)
              end
              

            # if isssl

            #   smtp = SMTP.new({:address => host,
            #                    :port => port,
            #                    :domain => 'localhost.localdomain',
            #                    :user_name => account,
            #                    :password => pwd,
            #                    :ssl => isssl,
            #                    :read_timeout         =>15,
            #                    :openssl_verify_mode  => 'none'  #wps邮箱必须加这个
            #                   }
            #   )
            #   smtp.deliver!(mailContent, account, receiver)
            # else

            #   # 此smtp是我们自己的smtp类，非官方的。后面才调用官方的smtp类
            #   smtp = KsSmtp.new(host, port, account, pwd, receiver, subject, body, []) #[tempfile.path]

            #   smtp.sendEmail
            # end

            # if isssl
            #   smtp = SMTP.new({:address => host,
            #                    :port => port,
            #                    :domain => 'localhost.localdomain',
            #                    :user_name => account,
            #                    :password => pwd,
            #                    :ssl => isssl,
            #                    :openssl_verify_mode  => 'none'
            #                    }
            #   )
            #   ret=smtp.deliver!(mailContent, account, receiver)
            #   # p 'sendTestmail ret'
            #   # p ret.toString  #里面
            #   # p ret.to_s
            # else
            #   smtp = KsSmtp.new(host, port, account, pwd, receiver, subject, body, [])
            #   #smtp.enable_tls()
            #   smtp.sendEmail
            # end

            result["result"]="ok"
            result["msg"]="发送测试邮件成功！"
          else
            result["result"]="error"
            result["msg"]="发送测试邮件出错:邮箱为空"
          end


        else
          result["result"]="error"
          result["msg"]="发送测试邮件出错:未设置邮箱用户、密码及SMTP服务器和端口！"
        end



      rescue Exception => e
        result['result']="error"
 
        errmsg=e.message
        errmsg = errmsg.force_encoding('GBK')  
        errmsg = errmsg.encode('UTF-8')   

        if errmsg.include?"535"
           errmsg='密码或邮箱或设置可能不正确 '+errmsg 
        elsif errmsg.include?"554"
           errmsg='发送频率过高或被当成垃圾邮件 '+errmsg
        elsif errmsg.include?"550"
           errmsg='邮箱地址不对或超出邮件商每天额度或邮箱已满 '+errmsg
        elsif errmsg.include?"553"
           errmsg='发送邮箱地址被拒绝或不允许的邮箱名称 '+errmsg 
        elsif errmsg.include?"500"
           errmsg='收件人地址格式不正确 '+errmsg 
        elsif errmsg.include?"501"
           errmsg='不正确的邮箱地址 '+errmsg     
        elsif errmsg.include?"451"
           errmsg='邮箱服务器已经关闭或请求邮件操作被中止 '+errmsg            
        else
           puts "未知"
        end
        result['msg']=errmsg  #  "出错:"+  e.message.force_encoding("UTF-8")
 
      ensure

        
        puts (result.to_json)
        return result.to_json
      end

    end

    def saveSmtpCfg(smtpserver,port)
      puts (__method__.to_s)
      begin
        result={}
 
        puts 'smtpserver'
        puts smtpserver
        settings =KRubyAccountEmailSettings.new    
        settings.setRegValue('smtpserver', smtpserver)
        settings.setRegValue('port', port)
        # if sheet.Cells(3, 2).value != ''
        #   sheet.Cells(3, 2).value=''
        #   sheet.Cells(4, 2).value=''
        # end

        # sheet=AddWorkSheet('KSO_Salary_Config',false,true)

        # sheet.Cells(3, 1).value="SMTP服务器".to_s
        # sheet.Cells(4, 1).value="端口"

        # sheet.Cells(3, 2).NumberFormatLocal = "@"
        # sheet.Cells(3, 2).value=map['smtpserver'].toString()
        # sheet.Cells(4, 2).NumberFormatLocal = "@"
        # sheet.Cells(4, 2).value=map['port'].toString()
        result['result']="ok"
        result['msg']="邮件服务器配置保存成功"
      rescue Exception => e
        result['result']="error"
        result['msg']="邮件服务器配置保存出错"
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure
        
        puts (result.to_json)
        return result.to_json
      end

    end

     

    #单击打开查看发送日志内容
    def openSendLog(worksheetname)
 
      puts (__method__.to_s)
      begin
        result={}
        
        logSheetName=worksheetname

        if !logSheetName.nil?
          KSO_SDK::Application.ActiveWorkbook.Sheets(logSheetName).Visible=-1
          KSO_SDK::Application.ActiveWorkbook.Sheets(logSheetName).Activate
          result["result"]="ok"
          result['msg']="查看发送日志成功"
        end
      rescue Exception => e
        result['result']="error"
        result['msg']="查看发送日志出错"
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure
 
        puts (result.to_json)
        return result.to_json
      end
    end

    #删除发送日志内容
    def deleteSendLog(worksheetname)
      puts (__method__.to_s)
      begin
        result={}
        
        logSheetName=worksheetname

        if !logSheetName.nil?
          # puts logSheetName.to_s
          KSO_SDK::Application.DisplayAlerts = true 
 
          KSO_SDK::Application.ActiveWorkbook.Sheets(logSheetName).Delete
          KSO_SDK::Application.DisplayAlerts = true
          result["result"]="ok"
          result['msg']="删除发送日志成功"
        end
      rescue Exception => e
        result['result']="error"
        result['msg']="删除发送日志出错"
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure
        puts (result.to_json)
        return result.to_json
      end
    end

    # 获取已发送日志列表
    def sendLogList()
      puts (__method__.to_s)
      begin
 
        result={}

        arrLog=[]
        p KSO_SDK::Application.ActiveWorkbook.Sheets.count().to_s
        if !KSO_SDK::Application.ActiveWorkbook.Sheets.nil?
          KSO_SDK::Application.ActiveWorkbook.Sheets.each do |sheet|

            sheetName =sheet.name
            if sheetName.include?('发送日志_')

              logItem={}
              logItem['id']="1"
              logItem['diplayname']=sheetName
              logItem['worksheetname']=sheetName
              logItem['sendtime']=sheet.Cells(1, 2).value
              arrLog.push(logItem)

            end
          end
        end

        arrLog.sort! {|a, b| b['diplayname'] <=> a['diplayname']}

        result["data"]=arrLog
        result["result"]="ok"
        result['msg']="获取已发送日志列表成功"
      rescue Exception => e
        result['result']="error"
        result['msg']="获取已发送日志列表出错"
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure

        
        puts (result.to_json)
        return result.to_json
      end

    end



    # 获取选择工资明细表 表头tree
    def loadTemplateSalaryItem()
      puts (__method__.to_s)
 
      result={}
      result["result"]="ok"

      result["msg"]="获取选择工资明细表头成功！"
      if checkColumnChanged?
        checkSalaryItemRange(true)
        checkEmailField()
        result['result']="refresh"
        result['msg']="工资明细表头有改变，请重新选择表头！"
      end

      begin



        sheet=AddWorkSheet('KSO_Salary_Config',false,true)

        if !sheet.nil?
          if sheet.Cells(7, 2).value.to_s != ''
            rng=KSO_SDK::Application.ActiveWorkbook.Sheets(1).Range(sheet.Cells(7, 2).value.to_s)
            arrLog=createJson(rng, false)
            data={}
            data["list"]=arrLog
            result["data"]=data

          else
            #toDolist：如果以前没有选择标题，要自动判断标题的范围，并全选所有项目
          end
        end
      rescue Exception => e
        result['result']="error"
        result['msg']="获取选择工资明细表头出错"
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure


        puts (result.to_json)
        return result.to_json

      end

    end

    def testGetData()
      puts (__method__.to_s)

      sheet=AddWorkSheet('KSO_Salary_Config')
      if !sheet.nil?

        jsdata=sheet.Cells(17, 2).value.to_s
        p jsdata.to_s
        if !jsdata.empty?
          p '1'
          p jsdata.to_s
          jsn = JSON.parse(jsdata)
          p '2'
          @newdata=jsn['list']
          newdata=recurGetSalaryData(@newdata, 10, true)
          p 'newdata:'+newdata.to_json
        end
      end

      # #newdata='[{"label":"序号","address":"$C$5","selected":2,"value":3.0},{"label":"姓名","address":"$D$5","selected":0,"value":"李四"}]'
      # # #newdata.delete_if{|x|x["name"]="2"}
      #  newdata.delete_if{|x|x["selected"]==0}


    end

    #循环读取选择的标头对应的实际数据
    def recurGetSalaryData(data, row, justSel)
      puts (__method__.to_s)
      begin

        sheet=KSO_SDK::Application.ActiveWorkbook.Sheets(1)
        if data.class.to_s=="Array" #datalistArray
          data.delete_if {|x| x["selected"]==0} if justSel
          cnt=data.size
          i=0
          while i<cnt
            # p 'value:'+sheet.Cells(row,sheet.range(data[i]["address"]).column).value.to_s
            if !data[i]["children"].nil?
              data[i]["value"]=""
              data[i]["children"].delete_if {|x| x["selected"]==0} if justSel
              cnt1=data[i]["children"].size
              i1=0
              while i1<cnt1
                if !data[i]["children"][i1]["children"].nil?
                  data[i]["children"][i1]["value"]=""
                  data[i]["children"][i1]["children"].delete_if {|x| x["selected"]==0} if justSel
                  cnt2=data[i]["children"][i1]["children"].size
                  i2=0
                  while i2<cnt2

                    if !data[i]["children"][i1]["children"][i2]["children"].nil?
                      data[i]["children"][i1]["children"][i2]["value"]=""
                      data[i]["children"][i1]["children"][i2]["children"].delete_if {|x| x["selected"]==0} if justSel
                      cnt3=data[i]["children"][i1]["children"][i2]["children"].size
                      i3=0
                      while i3<cnt3
                        if !data[i]["children"][i1]["children"][i2]["children"][i3]["children"].nil?
                          data[i]["children"][i1]["children"][i2]["children"][i3]["value"]=""
                          data[i]["children"][i1]["children"][i2]["children"][i3]["children"].delete_if {|x| x["selected"]==0} if justSel
                        else
                          data[i]["children"][i1]["children"][i2]["children"][i3]["value"]=sheet.Cells(row, sheet.range(data[i]["children"][i1]["children"][i2]["children"][i3]["address"]).column).Text
                        end
                        i3+=1
                      end
                    else
                      data[i]["children"][i1]["children"][i2]["value"]=sheet.Cells(row, sheet.range(data[i]["children"][i1]["children"][i2]["address"]).column).Text
                    end
                    i2+=1
                  end
                else
                  data[i]["children"][i1]["value"]=sheet.Cells(row, sheet.range(data[i]["children"][i1]["address"]).column).Text
                end

                i1+=1
              end
            else
              #p 'address:row:'+row.to_s+',column:'+sheet.range(data[i]["address"]).column.to_s
              data[i]["value"]=sheet.Cells(row, sheet.range(data[i]["address"]).column).Text
            end
            i+=1
          end
        end

      rescue Exception => e
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure
        return data
      end

    end


    #递归读取选择的标头数据保存到excel配置表中
    def recurSaveSalaryItem(data, seqno)
      puts (__method__.to_s)
      begin

        sheet=AddWorkSheet('KSO_Salary_Config',false,true)

        if data.class.to_s=="Array" #datalistArray
          cnt=data.size
          i=0
          while i<cnt
            seqno=seqno+1
            #p 'data['+i.to_s+']class:'+data[i].class.to_s
            #p seqno.to_s+'-'+data[i]['label'].to_s+'-'+data[i]["address"].to_s+'-'+data[i]["selected"].to_s
            sheet.Cells(seqno, 5).value=data[i]['label']
            sheet.Cells(seqno, 6).value=data[i]["address"]
            sheet.Cells(seqno, 7).value=data[i]["selected"].to_i
            if !data[i]["children"].nil?
              sheet.Cells(seqno, 8).value=data[i]["children"].size
              if data[i]["children"].class.to_s=="Array"
                #p 'haschild'
                seqno=recurSaveSalaryItem(data[i]["children"], seqno)
              end
            else
              sheet.Cells(seqno, 8).value=0
            end

            i+=1
          end

        else

        end

      rescue Exception => e
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure
        return seqno
      end

      #return seqno
      #cnt=jsn['data']['list'].size
    end

    #递归取Tree的json
    def getChildJson(item)
      #puts (__method__.to_s)
      i=0
      arrHash=[]
      cnt=item.childCount()
      if cnt<1
        return arrHash
      else
        while i<cnt
          cnode=item.child(i)
          if (!cnode.nil?)

            if cnode.childCount()<1
              tmpHash={}
              tmpHash['id']=cnode.text(1)
              tmpHash['label']=cnode.text(0)
              tmpHash["address"]=cnode.text(2)
              tmpHash["selected"]=cnode.checkState(0).to_i
              arrHash.push(tmpHash)
            else
              tmpHash={}
              tmpHash['id']=cnode.text(1)
              tmpHash['label']=cnode.text(0)
              tmpHash["address"]=cnode.text(2)
              tmpHash["selected"]=cnode.checkState(0).to_i
              arrHashChild=getChildJson(cnode)
              tmpHash["children"]=arrHashChild
              arrHash.push(tmpHash)
            end
          end
          i+=1
        end
      end
      return arrHash
    end

    #创建标题Tree并生成整个json
    def createJson(rng, selAll)
      puts (__method__.to_s)
      @twTmp=Qt::TreeWidget.new()
      @twTmp.deleteLater()
      @twTmp.setColumnCount(3)
      @twTmp.setColumnWidth(0, 200)
      @twTmp.setColumnWidth(1, 200)
      @twTmp.setColumnWidth(2, 200)
      labelHeader = ['标题', '列', '地址']
      @twTmp.setHeaderLabels(labelHeader)
      @twTmp.move(60, 60)
      @twTmp.resize(300, 600-40-60)
      @twTmp.setSelectionMode(Qt::AbstractItemView::ExtendedSelection)

      if rng!=false
        p rng.Address.to_s #+':'+rng.Rows.Count.to_s+'-'+rng.Columns.Count.to_s
      else
        p "请先选择正确标题区域！"
      end

      rowCnt=rng.Rows.Count
      colCnt=rng.Columns.Count
      i=1
      rootArr = Array.new(10)
      @twTmp.clear()

      nodRoot=Qt::TreeWidgetItem.new(@twTmp, ["总节点", "all", "all"])
      # nodRoot.setIcon(0,icon)
      # nodRoot.setCheckState(0,Qt::Unchecked)

      while i<=colCnt do
        j=1
        while j<=rowCnt do
          if rng.cells(j, i).value == '' or rng.cells(j, i).value.nil?
          else
            labelNode = ["#{rng.cells(j, i).value.to_s}", "#{rng.cells(j, i).column}", "#{rng.cells(j, i).address}"]
            if j==1
              rootArr[j]=addRootNode(nodRoot, labelNode, Qt::Icon.new("#{File.dirname(__FILE__)}/image/leaf.ico"))
            else
              if !rootArr[j-1].nil?
                rootArr[j]=addChildNode(rootArr[j-1], labelNode, Qt::Icon.new("#{File.dirname(__FILE__)}/image/leaf.ico"))
              end
            end

            if selAll #默认全选
              rootArr[j].setCheckState(0, Qt::Checked)
            else

              sheet=AddWorkSheet('KSO_Salary_Config',false,false)  #只是取数据进行对比，不写数据


              if !sheet.nil?
                selState=KSO_SDK::Application.IFERROR(KSO_SDK::Application.VLOOKUP(rootArr[j].text(2), sheet.Range("$F$1:$G$100"), 2, false), 0).to_i
                if KSO_SDK::Application.IFERROR(KSO_SDK::Application.VLOOKUP(rootArr[j].text(2), sheet.Range("$F$1:$G$100"), 2, false), 0).to_i<0
                  rootArr[j].setCheckState(0, Qt::Unchecked)
                else
                  rootArr[j].setCheckState(0, selState)
                end
                #p 'checked:'+rootArr[j].checkState(0).to_s+'-'+Qt::PartiallyChecked.to_s
                #p rootArr[j].text(0)+'--'+rootArr[j].text(2)+'--'+KSO_SDK::Application.IFERROR(KSO_SDK::Application.VLOOKUP(rootArr[j].text(2),sheet.Range("$E$1:$F$100"),2,false),0)
              end
            end


          end
          j+=1
        end
        i+=1
      end
      i=0
      tmpRootHash=[]
      cnt=@twTmp.topLevelItemCount()
      while i<cnt
        tmpRootHash=getChildJson(@twTmp.topLevelItem(i))
        i+=1
      end
      #Qt:Object.delete @twTmp

      return tmpRootHash
    end


    def addRootNode(parent, textList, icon)
      tvSubNode=Qt::TreeWidgetItem.new(parent, textList)
      return tvSubNode
    end

    def addChildNode(parent, textList, icon)
      tvSubNode=Qt::TreeWidgetItem.new(parent, textList)
      return tvSubNode
    end


    # 获取邮件预览姓名列表
    def loadNameList()
      puts (__method__.to_s)
      begin
         
        result={}
        arrLog=[]
        data={}


        sheet=AddWorkSheet('KSO_Salary_Config',false,false)
        sheetSalary=KSO_SDK::Application.ActiveWorkbook.Activesheet  



        # if !sheet.nil?
        #   if !checkNameExist?
        #      p 'Name No Exist'
        #      checkSalaryItemRange(true) #为避免姓名列修改了，这里也强制性再取一次姓名列
        #   end



        #   if sheet.Cells(11, 2).value.nil?
        #     checkEmailField("test")
        #   end
        # else

        # end



        sheet=AddWorkSheet('KSO_Salary_Config',false,false)
        if !sheet.nil?

          startRow=0
          nameCol=0
          emailCol=0
          #rng.offset(1,0).address.to_s
          #param['namerange']=sheet.Cells(15, 2).value
          #param['emailrange']=sheet.Cells(16, 2).value
          if sheet.Cells(15, 2).value.to_s != ''
             rng=sheetSalary.range(sheet.Cells(15, 2).value).offset(1,0) 
             startRow=rng.row
             nameCol=rng.column

          end   
          puts sheet.Cells(16, 2).value.to_s
          if sheet.Cells(16, 2).value.to_s != ''
             rng=sheetSalary.range(sheet.Cells(16, 2).value).offset(1,0) 
             #startRow=rng.row
             emailCol=rng.column

          end 
  
          if emailCol>0 && nameCol>0

            salarySheet=KSO_SDK::Application.ActiveWorkbook.Activesheet #.Sheets(1)
            endRow=salarySheet.Cells(20000, nameCol).End(-4162).Row #dataEndRow=sheet.Cells(65536, nameCol).End(3).Row
            endRow=10000 if endRow>10000
            while startRow<=endRow
              item={}
              item["id"]=startRow
              item["name"]=salarySheet.Cells(startRow, nameCol).value.to_s

              # todo address 在表格中是空值，返回结果是表列名
              item["address"]=salarySheet.Cells(startRow, nameCol).address.to_s
              # p startRow
              # p item["name"]
              item["email"]=salarySheet.Cells(startRow, emailCol).value.to_s
              item["selected"]=true
              arrLog.push(item)
              startRow+=1
            end
            result['result']="ok"
            result['msg']="获取邮件预览姓名列表成功"
          else
            result['result']="error"
            result['msg']="不存在邮箱列，请先添加好邮箱列！"
          end
        else
          result['result']="error"
          result['msg']="配置表不存在！"
        end

      rescue Exception => e
        result['result']="error"
        result['msg']="获取邮件预览姓名列表出错:"+e.message
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure
        data["list"]=arrLog
        result["data"]=data
        puts result.to_json
        puts (result['result']+'-'+result['msg'])
        return result.to_json
 
      end

    end


    #判断姓名列是否正确
    def checkNameExist?()
        ret=false
        oldrowName=1
        oldcolName=1
        sheet=AddWorkSheet('KSO_Salary_Config',false,false)
        if !sheet.nil?

          oldrowName=sheet.Cells(10, 4).value.to_i if !sheet.Cells(10, 4).value.nil?
          oldcolName=sheet.Cells(10, 2).value.to_i if !sheet.Cells(10, 2).value.nil?
          p 'rowName'
          p oldrowName
          p oldcolName

          sheetSalary=KSO_SDK::Application.ActiveWorkbook.Activesheet #.Sheets(1)
          puts

          puts sheetSalary.cells(oldrowName,oldcolName).value
          puts sheet.Cells(10, 3).value
          if sheetSalary.cells(oldrowName,oldcolName).value != colName=sheet.Cells(10, 3).value #姓名列有变化
              ret=false
              #checkSalaryItemRange(true) #为避免姓名列修改了，这里也强制性再取一次姓名列
          else
              ret=true
          end
        else
           ret=false
        end
        return ret
    end

    # 获取邮件预览内容
    def loadEmailContent(address)
      # getBalance
      puts (__method__.to_s)
      result={}
      result['result']="ok"
      if checkColumnChanged?
        p 'ColumnChanged'
        checkSalaryItemRange(true)
        checkEmailField()
        result['result']="refresh" #refresh #result['result']="warning"
        result['msg']="工资明细表头有改变，已自动匹配表头，如需调整，请重新选择表头！"
      else
        p 'NoColumnChanged'
      end


      begin
 


        # todo 当 address = '' 时，返回标准模板， address != '' 时，按照id值返回模板

        sheetSalary=KSO_SDK::Application.ActiveWorkbook.ActiveSheet #.Sheets(1)
        nameRow=0
        nameRow=sheetSalary.range(address).row if !address.empty?


        sheet=AddWorkSheet('KSO_Salary_Config')
        #如果没有传递指定的行过来
        if nameRow<1
          if !sheet.nil?
            dataStart=sheet.Cells(8, 2).value
            if !dataStart.nil?
              nameRow=dataStart.to_i
            end
          end
        end

        nameRow=8 if nameRow<1
        p nameRow
        data={}


        if !sheet.nil?

          jsdata=sheet.Cells(17, 2).value
          if !jsdata.nil? && !jsdata.empty?
            if jsdata!='null'

              jsn = JSON.parse(jsdata)
              @newdata=jsn['list']
              newdata=recurGetSalaryData(@newdata, nameRow, true)
              data["list"]=newdata
              result["data"]=data #newdata.to_json
            else
              result['result']="error"
              result['result']="没有标题列或未选择标题范围！"
            end
          else #还没有选择标题范围
            # rng=sheetSalary.cells.Find(:what=>"姓名") # or :what=>"姓 名"
            # p 'search name'
            # p rng.to_s
            # if rng!=false
            #   p rng.Address.to_s+':'+rng.Rows.Count.to_s+'-'+rng.Columns.Count.to_s
            #   rowHeader=rng.Row
            #   colName=rng.Column
            #   p rowHeader.to_s
            # else
            #   rng=sheetSalary.cells.Find(:what=>"姓 名")
            #   if rng!=false
            #     rowHeader=rng.Row
            #     colName=rng.Column
            #     p rng.Address.to_s  #+':'+rng.Rows.Count.to_s+'-'+rng.Columns.Count.to_s
            #   else
            #     p "请先选择正确标题区域！"
            #   end
            # end
          end
        end
      rescue Exception => e
        result['result']="error"
        result['msg']="邮件内容预览出错"+e.message
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure


        puts (result.to_json)
        return result.to_json
  

      end

    end


    def checkEmailField()
      puts (__method__.to_s)
      result={}
      begin
 
        rowHeader=0 #标题开始行
        colName=0 #姓名开始列

        #将来可以增加判断邮箱列的值是否是现有的值。如果是，则不再检查
        #或如果是重选表头，就重新自动识别一次

        sheetSalary=KSO_SDK::Application.ActiveWorkbook.Sheets(1)
 


        rng=sheetSalary.cells.Find(:what => "邮箱") # or :what=>"邮箱"
        if rng.nil?
          rng=sheetSalary.cells.Find(:what => "邮 箱") # or :what=>"邮箱"
        end
        if rng.nil?
          rng=sheetSalary.cells.Find(:what => "email") # or :what=>"邮箱"
        end

        if rng.nil?
          rng=sheetSalary.cells.Find(:what => "e-mail") # or :what=>"邮箱"
        end


        if rng.nil?
          rng=sheetSalary.cells.Find(:what => "mail") # or :what=>"邮箱"
        end

        if rng.nil?
          rng=sheetSalary.cells.Find(:what => "邮件") # or :what=>"邮箱"
        end

        if rng.nil?
          p 'Can\'t find email column'
          sheet=AddWorkSheet('KSO_Salary_Config',false,true)
          if !sheet.nil?

            jsdata=sheet.Cells(17, 2).value
            if !jsdata.nil? && !jsdata.empty?
              if jsdata!='null'

              else
                result['result']="error"
                result['result']="没有标题列或未选择标题范围！"
              end
              rng=sheetSalary.cells.Find(:what => "姓名") # or :what=>"姓 名"

              if rng!=false
                p rng.Address.to_s+':'+rng.Rows.Count.to_s+'-'+rng.Columns.Count.to_s
                rowHeader=rng.Row
                colName=rng.Column

              else
                rng=sheetSalary.cells.Find(:what => "姓 名")
                if rng!=false
                  rowHeader=rng.Row
                  colName=rng.Column

                else
                  p "请先选择正确标题区域！"
                end
              end
            end
            #邮箱列还是插在最后一列  colName保存的是标题区域最大的列
            if sheet.Cells(7, 2).value.to_s != ''
              rng=KSO_SDK::Application.ActiveWorkbook.Sheets(1).Range(sheet.Cells(7, 2).value.to_s)
              colName=rng.column+rng.columns.count-1
            end

          end
          p rowHeader
          if rowHeader>0

            #colMax=sheetSalary.Cells.SpecialCells(11).Column #xlCellTypeLastCell
            sheetSalary.Activate
            sheetSalary.Columns(colName+1).Insert
            sheetSalary.Cells(rowHeader, colName+1).value="邮箱"

            sheetSalary.Columns(colName).Select

            KSO_SDK::Application.ActiveWindow.Selection.Copy
            sheetSalary.Columns(colName+1).Select
            KSO_SDK::Application.ActiveWindow.Selection.PasteSpecial(:Paste => -4122, :Operation => -4142, :SkipBlanks => false, :Transpose => false)
            sheetSalary.Columns(colName+1).ColumnWidth=15

            KSO_SDK::Application.CutCopyMode = false

            sheet=AddWorkSheet('KSO_Salary_Config',false,true)
            if !sheet.nil?
              sheet.Cells(11, 1).value='邮箱列'
              sheet.Cells(11, 2).value=colName+1
              sheet.Cells(11, 3).value=sheetSalary.Cells(rowHeader, colName+1).value.to_s
              sheet.Cells(11, 4).value=rowHeader.to_s
            end

          end
          result["result"]="ok"
          result["msg"]="检查邮箱列成功！"
        else
          sheet=AddWorkSheet('KSO_Salary_Config',false,true)
          if !sheet.nil?
            if sheet.Cells(11, 1).value!='邮箱列'
              puts '邮箱列'
              sheet.Cells(11, 1).value='邮箱列'
            end
            if sheet.Cells(11, 2).value.to_i!=rng.column
              puts '邮箱列数'
              sheet.Cells(11, 2).value=rng.column.to_s
            end
            if sheet.Cells(11, 3).value!=rng.value.to_s
              puts '邮箱内容'
               sheet.Cells(11, 3).value=rng.value.to_s
            end
            puts sheet.Cells(11, 4).value.to_i
            puts rng.row
            if sheet.Cells(11, 4).value.to_i!=rng.row
              puts '邮箱行'
              sheet.Cells(11, 4).value=rng.row.to_s
            end
          end
          endRow=sheetSalary.Cells(20000, rng.column).End(-4162).Row
          endRow=10000 if endRow>10000
          rngAddr='$'+numToW(rng.column)+1.to_s+':'+numToW(rng.column)+endRow.to_s
          p rngAddr

          sheetSalary.Activate
          sheetSalary.Range(rngAddr).Select
        end
      rescue Exception => e
        result['result']="error"
        result['msg']="检查邮箱列出错"+e.message
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)

      ensure
        result['colEmail']=colName.to_i+1
        # setResult(context, Qt::Variant.new(result.to_json))
      end
      puts (result.to_json)


    end

    def checkConfig()
      puts (__method__.to_s)
      begin
        result={}
        msg='' 
        
        sheet=AddWorkSheet('KSO_Salary_Config',false,false)
 
        if !sheet.nil?
          puts sheet.Cells(7, 2).value
          if sheet.Cells(7, 2).value == '' or sheet.Cells(7, 2).value.nil?
              msg=msg+' 表头区域未设置'
          end 
          if sheet.Cells(10, 2).value == '' or sheet.Cells(10, 2).value.nil?
              msg=msg+' 姓名列未设置'
          end 
          if sheet.Cells(11, 2).value == '' or sheet.Cells(11, 2).value.nil?
              msg=msg+' 邮箱列未设置'
          end  
 
          if msg=='' 
              result['result']="ok"
              result['msg']="配置检查成功"
          else
              result['result']="error"
              result['msg']=msg 
          end  
        else
          result['result']="error"
          result['msg']="您还没有进行设置，请先设置姓名列邮箱列！"
        end
      
 
      rescue Exception => e
 
        result['result']="error"
        result['msg']="配置检查出错"
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure
        puts (result.to_json) 
        return result.to_json
        
      end
    end


    # 保存选择的工资表头
    def saveTemplateSalaryItem(data)
      puts (__method__.to_s)
      result={}
      begin
 
 
        sheet=AddWorkSheet('KSO_Salary_Config',false,true)
        if !sheet.nil?

          sheet.Cells(17, 1).value='工资表头json'
          sheet.Cells(17, 2).value=data

        end

        jsn = JSON.parse(data) #data.to_json

        if recurSaveSalaryItem(jsn['list'], 0)==0
          result["result"]="ok"
          result["msg"]="保存工资表头成功！"
        else
          result["result"]="error"
          result["msg"]="保存工资表头出错2！"
        end

      rescue Exception => e
        result['result']="error"
        result['msg']="保存工资表头出错3"
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure
        puts (result.to_json)
        return result.to_json
         
      end
    end

    # 获取邮件模板页眉页脚(前后缀) 内容形式 是否图片附件等内容
    def loadTemplateHdFt()
      puts (__method__.to_s)
      result={}
      begin
 
        subject=""
        header=""
        footer=""
        bodytype=""
        attachpic=""
        hlayout=""

        sheet=AddWorkSheet('KSO_Salary_Config',false,false)
        if !sheet.nil?
          subject=sheet.Cells(24, 2).value  #标题
          header=sheet.Cells(25, 2).value    #前缀
          footer=sheet.Cells(26, 2).value    #后缀

          bodytype=sheet.Cells(27, 2).value  #邮件内容类型
          attachpic=sheet.Cells(28, 2).value #是否带图片附件
          hlayout=sheet.Cells(23, 2).value #是否横向工资条
        end

        result["result"]="ok"
        result["msg"]="获取页眉页脚成功！"

      rescue Exception => e
        result['result']="error"
        result['msg']="获取页眉页脚成功出错"+e.message
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)

      ensure

        header="您好，以下是您的工资单，请查收！" if header.nil?
        footer="<br>祝好！<br>此工资条仅供员工本人浏览，如有任何疑问，请及时与人力资源部薪酬组联系！<br>" if footer.nil?
        result['subject']=subject
        result['header']=header
        result['footer']=footer
        result['bodytype']=bodytype
        result['attachpic']=attachpic
        result['hlayout']=hlayout
        
        return result.to_json
      end

    end

    # 保存邮件模板前后缀内容
    def saveTemplateHdFt(subject,header,footer,bodytype,attachpic,hlayout)
      puts (__method__.to_s)
      result={}
      begin
        
        sheet=AddWorkSheet('KSO_Salary_Config',false,true)
        if !sheet.nil?
          sheet.Cells(23, 1).value='横向工资条'
          sheet.Cells(23, 2).value=hlayout

          sheet.Cells(24, 1).value='标题'
          sheet.Cells(24, 2).value=subject

          sheet.Cells(25, 1).value='页眉'
          sheet.Cells(25, 2).value=header
          sheet.Cells(26, 1).value='页脚'
          sheet.Cells(26, 2).value=footer
          sheet.Cells(27, 1).value='邮件内容类型'
          sheet.Cells(27, 2).value=bodytype
          sheet.Cells(28, 1).value='图片附件'
          sheet.Cells(28, 2).value=attachpic

        end

        result["result"]="ok"
        result["msg"]="保存页眉页脚成功！"

      rescue Exception => e
        result['result']="error"
        result['msg']="保存页眉页脚出错"+e.message
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)

      ensure
        puts result.to_json
        return result.to_json
      end

    end

    def checkSalaryItemRange(autoDetect)
      puts (__method__.to_s)
      result={}
      noRange=false
      rowHeader=0 #标题开始行
      colName=0 #姓名开始列

      begin

        sheetSalary=KSO_SDK::Application.ActiveWorkbook.Sheets(1)
        sheet=AddWorkSheet('KSO_Salary_Config')
        if !sheet.nil?
          jsdata=sheet.Cells(10, 2).value.to_s
          itemRange=sheet.Cells(7, 2).value
          if !jsdata.nil? && !jsdata.empty?
            if jsdata=='null'
              noRange=true
            end
          else #还没有选择标题范围
            noRange=true
          end
        else
          noRange=true
        end

        if noRange || autoDetect

          rng=sheetSalary.cells.Find(:what => "姓名") # or :what=>"姓 名"

          if rng!=false
            rowHeader=rng.Row
            colName=rng.Column
          else
            rng=sheetSalary.cells.Find(:what => "姓 名")
            if rng!=false
              rowHeader=rng.Row
              colName=rng.Column
            else
              rng=sheetSalary.cells.Find(:what => "姓  名")
              if rng!=false
                rowHeader=rng.Row
                colName=rng.Column
              else
                p "请先选择正确标题区域！"
              end
            end
          end

          rowStart=0
          colStart=0
          rowEnd=0
          colEnd=0
          if rng!=false
            # rowCnt=rng.Rows.Count
            # colCnt=rng.Columns.Count
            rowCnt=rng.MergeArea.rows.count
            colCnt=rng.MergeArea.columns.count

            #临时用这个作为起点
            rowStart =rng.Row
            colStart=rng.Column

            #再判断姓名列到第1列之间有否空白列，连续1次空白 就判断为开始列
            colName=rng.Column
            nameText=rng.value.to_s
            i=colStart
            emptyCnt=0
            colTmp=0
            while i>0
              if sheetSalary.Cells(rowStart, i).Value.nil?
                colTmp=i if colTmp=0
                emptyCnt+=1
              else
                if sheetSalary.Cells(rowStart, i).Value.to_s.strip==''
                  colTmp=i if colTmp=0
                  emptyCnt+=1
                end
              end
              #emptyCnt+=1 if sheetSalary.Cells(rowCnt,i).Value.empty?
              if emptyCnt>0
                break
              end
              i-=1
            end

            colStart=colTmp+1 if colTmp>0

            rowEnd=rng.Row+rowCnt-1

            #取最大的列，但最大不超过100列
            colEnd=sheetSalary.Cells.SpecialCells(11).Column #xlCellTypeLastCell

            colEnd=100 if colEnd>100


            #再去除空白的列
            i=colEnd
            emptyCnt=0
            colTmp=0
            while i>0
              # p i.to_s+'-'+sheetSalary.Cells(rowStart,i).Value.to_s
              if !sheetSalary.Cells(rowStart, i).Value.nil? && sheetSalary.Cells(rowStart, i).Value.to_s.strip!=''
                colEnd=i
                break
              end
              i-=1
            end
            # p i
            colEnd=colStart if colEnd<colStart

            #合成标题区域的地址
            rngAddr='$'+numToW(colStart)+rowStart.to_s+':'+numToW(colEnd)+rowEnd.to_s

            rng=KSO_SDK::Application.ActiveWorkbook.Sheets(1).Range(rngAddr)
            result={}
            #保存配置
            arrLog=createJson(rng, true)
            data={}
            data["list"]=arrLog
            result["data"]=data


            sheet=AddWorkSheet('KSO_Salary_Config',false,true)
            if !sheet.nil?

              sheet.Cells(7, 1).value='标题区域'
              sheet.Cells(7, 2).value=rng.address


              sheet.Cells(13, 1).value='标题区域左上角值'
              sheet.Cells(13, 2).value=rng.cells(1).MergeArea.Cells(1, 1)

              sheet.Cells(14, 1).value='标题区域右下角值'
              sheet.Cells(14, 2).value=rng.cells(rng.count).MergeArea.Cells(1, 1)


              sheet.Cells(8, 1).value='数据开始行'
              sheet.Cells(8, 2).value=(rng.Row+rng.Rows.Count).to_s

              sheet.Cells(10, 1).value='姓名列'
              sheet.Cells(10, 2).value=colName
              sheet.Cells(10, 3).value=nameText
              sheet.Cells(10, 4).value=rowHeader.to_s

              sheet.Cells(17, 1).value='工资表头json'
              sheet.Cells(17, 2).value=data.to_json
              p __method__.to_s+':save'
              #KSO_SDK::Application.ActiveWorkbook.save
            end

            jsn = JSON.parse(result.to_json)
            recurSaveSalaryItem(jsn['data']['list'], 0) #将标题及所有标题全选保存到配置表中

          end

        end


          # if rowHeader>0
          #
          #   #colMax=sheetSalary.Cells.SpecialCells(11).Column #xlCellTypeLastCell
          #   sheetSalary.Columns(colName+1).Insert
          #   sheetSalary.Cells(rowHeader,colName+1).value="邮箱"
          #
          #   sheetSalary.Columns(colName).Select
          #
          #   KSO_SDK::Application.ActiveWindow.Selection.Copy
          #   sheetSalary.Columns(colName+1).Select
          #   KSO_SDK::Application.ActiveWindow.Selection.PasteSpecial(:Paste=>-4122,:Operation=>-4142,:SkipBlanks=>false,:Transpose=>false)
          #   sheetSalary.Columns(colName+1).ColumnWidth=15
          #   KSO_SDK::Application.CutCopyMode = false
          #
          # end


      rescue Exception => e

        p __method__.to_s+' error:'+e.message
          # puts ("出错位置:"+e.backtrace.inspect)

      ensure

      end


    end


    def numToW(num)
      return KSO_SDK::Application.ActiveWorkbook.ActiveSheet.Cells(1, num).Address(false, false).gsub("1", "")
    end


    # todo 新函数，发送邮件 sendStart 之前检查群发数量限制，目前是大于5需要购买
    def sendEmailListCheckLimitNumber(num)
       
      # 检查步骤
      # 1 判断是否登录WPS帐号
      #   1.1 已登录
      #     1.1.1 联网服务器(指定url) -> 获取该WPS帐号是否已购买
      #       1.1.1.1 已购买 -> 返回 '已购-无限制发送数量'结果 —> sendStart
      #       1.1.1.2 未购买 —> 返回 '未购买-限制5个-请购买'结果 -> 前端显示限制 -> 前端发起购买 -> 前端再次发起群发邮件请求 -> 重复步骤1
      #   1.2 未登录
      #     1.2.1 响应前端登录要求 -> 前端完成登录 -> 前端发起登录检查 -> 检查结果（无论是否登录成功）-> 重复步骤1
      #
      # todo more
    end


    #收件人设置
    def setRecipient(url)
 
       if !@webWidget.nil?
           @webWidget.close()
       end
       puts  url
       @broadcast.send('notify')
        # callbackToJS('onRefresh',{:url => "https://www.baidu.com"}.to_json);
        #$mainctrl.jsObj.


    end

    #发送邮件开始
    def sendStart(id,name,index,length,address,email,data,html,subject)
      # if !@webWidget.nil?
      #     @webWidget.close()
      # end
      # url="http://www.baidu.com"
      # puts url
      # puts $mainctrl
      # puts $mainctrl.webviewWidget
      # puts $mainctrl.jsObj
      # $mainctrl.webviewWidget.showWebView(url,$mainctrl.jsObj)
      # return
 

      puts (__method__.to_s)
      # todo 每一次发送都需要检测发送限制数量，超限不发
      result={}
      begin
        #address=address

        # id=id #map['id'].toInt
        # name=name #map['name'].toString
        # index=index #map['index'].toInt
        # length=length #map['length'].toInt
        receiver=email #map['email'].toString
        img_base64 =data #map['data'].toString
        #html =html #map['html'].toString
        topic=subject #map['subject'].toString
        puts html
        #toDolist :要增加判断传递过来的流是否base64及png
        #
        # p 'index:'+index.to_s
        # p 'length:'+length.to_s
        # 
        if index==1
            @fatalcnt=0
        end   
        settings =KRubyAccountEmailSettings.new  
        account=settings.getRegValue('address').toString
        pwd=settings.getRegValue('password').toString 
        host=settings.getRegValue('smtpserver').toString 
        port=settings.getRegValue('port').toString  
        

        sheet=AddWorkSheet('KSO_Salary_Config',false,false)
        if !sheet.nil?
          # account=sheet.Cells(1, 2).value.to_s
          # #pwd=sheet.Cells(2, 2).value.to_s
          # #psw=Base64.decode64(psw)
          # pwd=sheet.Cells(2, 2).value.to_s
          # host=sheet.Cells(3, 2).value.to_s
          # port=sheet.Cells(4, 2).value.to_i.to_s #变成了25.0 保存前加 '
          header=sheet.Cells(25, 2).value
          footer=sheet.Cells(26, 2).value
        end
        header="您好，以下是您的工资单，请查收！" if header.nil?
        footer="<br>祝好！<br>此工资条仅供员工本人浏览，如有任何疑问，请及时与人力资源部薪酬组联系！<br>" if footer.nil?


        if !receiver.empty?
          if !receiver.nil?
              receiver=receiver.gsub("\n","") #替换掉特殊字符
              receiver=receiver.gsub(" ","") #替换掉空格
          end

          if !host.nil?
              host=host.gsub("\n","") #替换掉特殊字符
              host=host.gsub(" ","") #替换掉空格
          end
          subject = "#{name},#{topic}"
          body = "<br><br> &nbsp;&nbsp;<b> #{header}</b> <br><br> "
          if !html.empty?
             body = body + "&nbsp;&nbsp;&nbsp;&nbsp;<br>#{html}" 
          else  
             body = body + "&nbsp;&nbsp;&nbsp;&nbsp;<img src='#{img_base64}'>"
          end   
          body = body + " <br><br> &nbsp;&nbsp;<b>#{footer}</b>"

          mailContent=getMailContent(account, receiver, subject, body, [])

          if port=='465'
            isssl=true
          else
            isssl=false
          end

          # puts account
          # puts receiver
          # puts isssl
          # puts port
          # puts host

          if port=='25'
            # if host !='smtp.wps.cn'
              smtp = SMTP.new({:address => host,
                                 :port => port,
                                 :domain => 'localhost.localdomain',
                                 :user_name => account,
                                 :password => pwd,
                                 :read_timeout         =>15,
                                 :openssl_verify_mode  => 'none'  #wps邮箱必须加这个
                                }
                )
              smtp.deliver!(mailContent, account, receiver)
            # else

            # end
          else

            smtp = SMTP.new({:address => host,
                               :port => port,
                               :domain => 'localhost.localdomain',
                               :user_name => account,
                               :password => pwd,
                               :ssl => isssl,
                               :authentication       => 'login',
                               :enable_starttls_auto => true,
                               :read_timeout         =>15,
                               :openssl_verify_mode  => 'none'  #wps邮箱必须加这个
                              }
              )

            smtp.deliver!(mailContent, account, receiver)
          end

 
          result["waittime"]=1000  #毫秒
          result["result"]="ok"
          result["msg"]="发送邮件成功！"

          settings =KRubyAccountEmailSettings.new  
          blc=settings.getRegValue('balance').toString     

   
          maxCnt=0
          if blc.nil? or blc== '' 
            maxCnt=50
 
          else  
            maxCnt=blc.to_i
 
            maxCnt-=1
 
            settings.setRegValue('balance', maxCnt.to_s)           
          end 
 

        else
          result["result"]="error"
          result["msg"]="发送邮件出错1:邮箱为空"
        end


      rescue Exception => e
        result['result']="error"
         
        errmsg=e.message
        errmsg = errmsg.force_encoding('GBK')  
        errmsg = errmsg.encode('UTF-8')   

        if errmsg.include?"535"
           errmsg='密码或邮箱或设置可能不正确 '+errmsg 
        elsif errmsg.include?"554"
           errmsg='发送频率过高或被当成垃圾邮件 '+errmsg
        elsif errmsg.include?"550"
           errmsg='邮箱地址不对或超出邮件商每天额度或邮箱已满 '+errmsg
        elsif errmsg.include?"553"
           errmsg='发送邮箱地址被拒绝或不允许的邮箱名称 '+errmsg 
        elsif errmsg.include?"500"
           errmsg='收件人地址格式不正确 '+errmsg 
        elsif errmsg.include?"501"
           errmsg='不正确的邮箱地址 '+errmsg     
        elsif errmsg.include?"451"
           errmsg='邮箱服务器已经关闭或请求邮件操作被中止 '+errmsg            
        else
           puts "未知"
        end
        result['msg']=errmsg  #  "出错:"+  e.message.force_encoding("UTF-8")
 
 
      ensure

        puts (result.to_json)
 
        if result['msg'].include?"554" or result['msg'].include?"550"
           @fatalcnt=0 if @fatalcnt.nil?
           @fatalcnt+=1
           
        end    

        if index==1
          @nowtime= Time.new
          @loginfoRow=1

        end
        @nowtime= Time.new if @nowtime.nil?
        sheetLog=AddWorkSheet('发送日志_'+@nowtime.strftime("%Y_%m_%d_%H_%M_%S"), true,true)

        if !sheetLog.nil?

          if index==1
            sheetLog.Cells(@loginfoRow, 1).value="开始发送时间："
            sheetLog.Cells(@loginfoRow, 1).Font.Bold = true
            sheetLog.Cells(@loginfoRow, 2).value=@nowtime.strftime("%Y-%m-%d %H:%M:%S")
            sheetLog.Cells(@loginfoRow, 2).Font.Bold = true
          end

          @loginfoRow+=1
          sheetLog.Cells(@loginfoRow, 1).value=name
          sheetLog.Cells(@loginfoRow, 2).value=receiver
          sheetLog.Cells(@loginfoRow, 3).value=result['msg']

          #如果是最后一条，则自适应一下列宽度
          if index==length
            sheetLog.Range("A:C").EntireColumn.AutoFit
          end
        end
        # todo 发送完毕->响应一次结束标记
         sendEnd(id)
        puts result.to_json  
        return result.to_json
 
      end

      
    end

    #Ruby调用js
    def sendProgress()
      # todo 使用单一模板逐一发送方式，不需要再在ruby中响应进度
      # result={}
      # result["result"]="ok"
      # result["msg"]="90"
      # callbackToJS("sendProgress", result.to_json)
    end

    def sendEnd(id)
      puts 'sendEnd3'
      result={}
      result["result"]="ok"
      result["msg"]="End"

      @fatalcnt=0 if @fatalcnt.nil?
      if @fatalcnt>3
           result['result']="fatal"
           result['msg']="出错:发送邮件多次出错，可能超出邮件服务商发送频率限制，将中止发送！" #,已发送#{index}/共#{length}人
      end 

      # todo 添加id
      result['id'] = id
      puts result.to_json
      callbackToJS("sendEnd", result.to_json)
    end


    def pickTemplateSalaryItem(url,bModal,width,height)
      puts (__method__.to_s)
      #先检测邮箱一次
      checkEmailField()

      begin
        if !@webWidget.nil?
          @webWidget.close()
        end
        result={}
 

        rng=GetRange()
        if rng.Rows.count>40
            result['result']="error"
            result['msg']="选择工资项目标题太多行" 
            return result.to_json
        end  

        arrLog=createJson(rng, true)
        data={}
        data["list"]=arrLog
        result["data"]=data
         

        sheet=AddWorkSheet('KSO_Salary_Config',false,true)
        if !sheet.nil?

          sheet.Cells(7, 1).value='标题区域'
          sheet.Cells(7, 2).value=rng.address

          p rng.address

          sheet.Cells(13, 1).value='标题区域左上角值'
          sheet.Cells(13, 2).value=rng.cells(1).MergeArea.Cells(1, 1)

          sheet.Cells(14, 1).value='标题区域右下角值'
          sheet.Cells(14, 2).value=rng.cells(rng.count).MergeArea.Cells(1, 1)


          sheet.Cells(8, 1).value='数据开始行'
          sheet.Cells(8, 2).value=(rng.Row+rng.Rows.Count).to_s

          sheet.Cells(17, 1).value='工资表头json'
          sheet.Cells(17, 2).value=data.to_json

        end

        jsn = JSON.parse(result.to_json)
        recurSaveSalaryItem(jsn['data']['list'], 0) #将标题及所有标题全选保存到配置表中

        result['result']="ok"
        result['msg']="选择工资项目标题成功"

      rescue Exception => e
        result['result']="error"
        result['msg']="选择工资项目标题出错"
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure
        
        closeBtn=false 
        navigateOnNewWidget(url,bModal,width,height,closeBtn)
        return result.to_json
      end

    end


    def checkColumnChanged?
      puts (__method__.to_s)
      changed=false
      begin


        sheetSalary=KSO_SDK::Application.ActiveWorkbook.Sheets(1)
        sheet=AddWorkSheet('KSO_Salary_Config',false,false)
        if !sheet.nil?
          rngAddr=sheet.Cells(7, 2).value.to_s

          if rngAddr != ''
            #puts sheet.Cells(13, 2).value.to_s,sheetSalary.Range(rngAddr).cells(1).MergeArea.Cells(1, 1).value.to_s
            if sheet.Cells(13, 2).value.to_s != sheetSalary.Range(rngAddr).cells(1).MergeArea.Cells(1, 1).value.to_s
              changed=true
            else
              #puts sheet.Cells(14, 2).value.to_s,sheetSalary.Range(rngAddr).cells(sheetSalary.Range(rngAddr).count).MergeArea.Cells(1, 1).value.to_s
              if sheet.Cells(14, 2).value.to_s != sheetSalary.Range(rngAddr).cells(sheetSalary.Range(rngAddr).count).MergeArea.Cells(1, 1).value.to_s
                changed=true
              end
            end
          end
        end
      rescue Exception => e
        changed=false
        puts ("出错信息:"+e.message)
        puts ("出错位置:"+e.backtrace.inspect)
      ensure
        return changed
      end
    end



    def localStorageGet(key)
 
      settings = KRubyPluginSettings.new
      p 'localStorageGet'
      res = settings.getRegValue(key)
      p res
      return res.to_s
      #setResult(context, res)
    end

    def localStorageSet(key,value,stamp)
 
      settings = KRubyPluginSettings.new
      # 虽然setString的第二个参数是QVariant，但直接传会报错，得转String那边再构造一个QVariant?
      settings.setRegValue(key, value)
    end

    def localStorageRemove(key)
      settings = KRubyPluginSettings.new
      settings.remove(key)
    end


    def onWorkbookChanged()

      puts (__method__.to_s)
      result={}
      result["result"]="ok"
      result["msg"]="End"

      callbackToJS("onWorkbookChanged", result.to_json)
 
    end

    def closeWindow()
      puts (__method__.to_s)
      if !@webWidget.nil?
         @webWidget.close()
      end

    end

    def zoomWebview(zoom)
      puts (__method__.to_s)
       
      #zoom = map['zoom'].toInt
      @webWidget.hide()
      if zoom == 1
        @webWidget.resize(@width, @height)
      else
        @webWidget.resize(@minWidth, @minHeight)
      end
      @webWidget.show()
    end

   def writePushTag(zt_id,oid,scene_id,job_id,isdefault)
 
      # $kyearreviewctl.officeApi.writePushTag(zt_id, oid, scene_id, job_id, isdefault)
    end

    # def getAppInfoJs()
    #   puts 'getAppInfoJs'
    #   #js_api = KSO_SDK::JsApi.new(self.web_widget)
    #   puts getAppInfo()
    #   return getAppInfo()
    #   #setResult(context, getAppInfo())
    # end

    def checkIsDocer()
      result = $kyearreviewctl.officeApi.isDocerDoc
      return "{\"isdocer\":\"#{result}\"}"
      
    end

    def GetHeader
      # result = Array.new
      # sendStruct = Struct.new(:name, :email, :file, :time)
      sheet = KSO_SDK::Application.ActiveWorkbook.Sheets('五险一金工资表')
      p 'sheetname:'+sheet.name
      rng=sheet.UsedRange
      p rng.Rows.Count
      return rng

    end    

    def GetRange()
      retRange=KSO_SDK::Application.InputBox(:prompt => "请输入标题区域", :title => "请选择工资表项目", :type => 8)
      return retRange
    end

    def getMailContent(sender, receiver, subject, body, attachments)
      ### Subject: =?utf-8?B?#{[subject].pack("m")} ?=  #这种会乱码
      boundary='--------------------'
      header =<<EOF
From: #{sender}
To: #{receiver}
Subject: #{subject}
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=#{boundary}

EOF

      body =<<EOF
--#{boundary}
Content-Type: text/html; charset=utf-8;

#{body}


EOF

      atts = ''
      attachments.each {|att|
        filecontent = File.binread(att)
        p 'attachname:'+att.to_s
        encodecontent = [filecontent].pack("m")
        atts +=<<EOF
--#{boundary}
Content-Type: application/octet-stream; charset=utf-8;
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="#{File.basename(att)}"

#{encodecontent}
EOF
      }

      ends =<<EOF
--#{boundary}--
.
EOF

      mailContent = header + body + atts + ends
      return mailContent

    end    

   
    
    def AddWorkSheet(sheetname, isvisible = false, addIfNoExist=false)
      wk=KSO_SDK::Application.ActiveWorkbook
      currSheet=wk.Activesheet
      begin
        sheet = wk.Sheets(sheetname)
      rescue
        sheet=nil
      ensure
        if sheet.nil?
          if addIfNoExist
            sheet = wk.Sheets.Add(:after => wk.Sheets(wk.Sheets.Count))
            sheet.name=sheetname
            currSheet.Activate
          end

          #wk.save
        end
      end
      if addIfNoExist
        if !isvisible
          #sheet.Visible=-1
          if sheet.Visible != 2
            sheet.Visible=2 #  2 -1
            #wk.save
          end
        end
      end
      return sheet

    end


  
     def getFileName(line = false)
      if line
        result = __FILE__ + getLine().to_s
      else
        result = __FILE__
      end
      result
    end
  
    def openWord(filepath)
      if File.exist?(filepath)
        KSO_SDK.getApplication().Documents.Open(filepath)
        return true
      end
      return false
    end
  
    def openExcel(filepath)
      if File.exist?(filepath)
        KSO_SDK.getApplication().Workbooks.Open(filepath)
        return true
      end
      return false
    end
  
    def openPowerPoint(filepath)
      if File.exist?(filepath)
        KSO_SDK.getApplication().Presentations.Open(filepath)
        return true
      end
      return false
    end
  
    def callback(methodName)
      klog methodName
      json = {:params => "content"}.to_json()
      klog json
      callbackToJS(methodName, json)
    end
  
    def test(url)
      command = KSO_SDK::getCurrentMainWindow().commands().command("CT_Home");
      puts command.class
      cmd = KRbTabCommand.new(KSO_SDK::getCurrentMainWindow(), KSO_SDK::getCurrentMainWindow())
      cmd.setDrawText(url)
      KSO_SDK::getCurrentMainWindow().commands().addCommand("CT_MyuHome", cmd)
      "call test"
    end
  
    #选中单元格
    def selectCell(range)
      KSO_SDK::Application.ActiveSheet.Range(range).Select
    end
  
    #获取已使用多少列
    def getSheetColumns()
      klog count = KSO_SDK::Application.ActiveSheet.UsedRange.Columns.Count
      count
    end
  
    #获取单元格的内容
    def getSheetValue(range)
      klog val = KSO_SDK::Application.ActiveSheet.Range(range).Value
      val = val.to_json if val.kind_of?(Array)
      val
    end
  
    #插入空白行
    #row：第一行插入
    def insertRow(row)
      klog KSO_SDK::Application.ActiveSheet.Rows(row).Insert
    end
  
    #获取当前选中的单元格位置
    def getSelection()
      KSO_SDK::Application.Selection.Address
    end
  
    #保存Excel文档
    def saveExcel()
      KSO_SDK::Application.ActiveWorkbook.Save
    end
  
    #编辑单元格的内容
    def setSheetValue(range,value)
      KSO_SDK::Application.ActiveSheet.Range(range).Value = value
    end
  
    #打开选择文件弹框
    def openFileDialog(title="打开文件",path= "C:", desc = "files", suffix="*.*")
      Qt::FileDialog::getOpenFileName(KSO_SDK::getCurrentMainWindow(), title,
        path,
        "#{desc} (#{suffix})")
    end
  
    #添加Sheet
    def addSheet()
      sheet = KSO_SDK::Application.WorkSheets.Add
      sheet.Name
    end
  
    #隐藏Sheet
    def hideSheet(name)
      KSO_SDK::Application.WorkSheets(name).Visible = false
    end
  
    #为单元格设置自动填充的内容
    def autoFill(src, sheet, dst)
      # to-do
    end
  
    #以模板的形式打开Excel
    def openExcelTemp(filepath)
      KSO_SDK::Application.Workbooks.Add(filepath)
    end
  
    #以模板的形式打开Word
    def openWordTemp(filepath)
      KSO_SDK::Application.Documents.Add(filepath)
    end
  
    #弹出Excel选择单元格选择窗
    def showInputBox(prompt, title)
      address = KSO_SDK::Application.InputBox(:prompt => prompt, :title => title, :type => 8)
      return address.Address if address
      false
    end
  
    #Excel文档另存为
    def excelSaveAs()
      filename = KSO_SDK::Application.GetSaveAsFilename()
      KSO_SDK::Application.ActiveWorkbook.SaveAs(filename)
    end
  
    #Excel关闭当前文档
    def closeActiveWorkbook()
      KSO_SDK::Application.ActiveWorkbook.Close()
    end
    
    #获取已使用的区域
    def getUsedRangeAddress()
      KSO_SDK::Application.ActiveSheet.UsedRange.Address
    end
  
    # 显示MessageBox
    def showMessageBox(title, text)
      btnMask = Qt::MessageBox::question(KSO_SDK.getCurrentMainWindow(), 'Title', 'ContentMessage', Qt::MessageBox::Yes, Qt::MessageBox::No)
    end
  
    #为单元格设置下来选值
    def setRangeInCellDropdownValidation(address, array)
      #{"type":3,"value":true,"alertStyle":1,"operator":1,"inCellDropdown":true,"formula1":"123,321,abc","formula2":""} 
      KSO_SDK::Application.ActiveSheet.Range(address).Validation().Add(3, 1, 1, array)
    end
  
    #为单元格添加批注
    def setComment(address, comment)
      KSO_SDK::Application.ActiveSheet.Range(address).AddComment(comment)
      nil
    end
  
    #获取插件存储文件路径
    def getStorageDir()
      KSO_SDK.getStorageDir(context)
    end

    #添加插件到收藏夹
    def addToFavorite()
      KSO_SDK.addFavorite(context)
    end
  
    private
  
    def getLine()
      __LINE__.to_s
    end


    private
    def getWidth(width)
       
      if width.nil? or width  == 0
        $kxApp.currentMainWindow.width * 3 / 4
      else
        width 
      end
    end

    def getHeight(height)
       
      if height.nil? or height  == 0
        $kxApp.currentMainWindow.height * 3 / 4
      else
        height 
      end
    end
  
  end

  class ShadowWebViewDialog < KSO_SDK::View::WebView

    def initialize(context)
      super(nil, context)
      border=KShadowBorder.new(self, self , false, 10)
    end

  end

 
  
  # class ShadowWebView < KSO_SDK::View::WebViewWidget

  #     def initialize(context)
  #       p 'ShadowWebView'

  #       super(context)
  #       current_main_window =KxWebViewWidget.getCurrentSubWindow

  #       border=KShadowBorder.new(self, self , false, 10)
  #       #setVisiable(true)

  #         # setAttribute(Qt::WA_TranslucentBackground,true)
  #     end
  # end
end
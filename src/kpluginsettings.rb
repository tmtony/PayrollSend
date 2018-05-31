=begin
** Created: 2017/12/25
**      by: 钟成
** Modified: 2018/01/18
**      by: tmtony(王宇虹)
**
** Description:注册表操作
=end

module SalaryMailPlugin
  class KRubyPluginSettings < KSettings
    def initialize
      super
 
      beginGroup($kxApp.productVersion)
 
      beginGroup("plugins")
      beginGroup("rubysalarymail")
      
    end

    def setRegValue(key, val)
      setValue(key, Qt::Variant::fromValue(val))
    end

    def getRegValue(key)
      var = value(key)
      return var
    end

    def isRegExist(key)
      return !value(key).isNull
    end

  end



  class KOfficeSpacePluginSettings < KSettings
    def initialize
      super
      beginGroup($kxApp.productVersion)
      beginGroup("plugins")
      beginGroup("officespace")
      beginGroup("transformguide")
      beginGroup("blacklist")
    end

    def writeDocerBlackList
      setValue("docer-et_payroll", Qt::Variant::fromValue(0))
    end
  end


  class KRubyAccountEmailSettings < KSettings
    def initialize
      super
      beginGroup($kxApp.productVersion)
      beginGroup("plugins")
      beginGroup("krubytemplate")
      beginGroup("1")  #插件ID，后面再接登录的 用户名
      userid=KSO_SDK.getCloudService().getUserInfo().userId
      if userid.nil?
          # puts '没有登录'
          # btnMask = Qt::MessageBox::information(KSO_SDK.getCurrentMainWindow(), '登录', '使用助手需要先登录WPS！请先登录！', Qt::MessageBox::Yes, Qt::MessageBox::Yes)
          userid=0      
      end   
      beginGroup(userid.to_s)
    end

    def setRegValue(key, val)
      setValue(key, Qt::Variant::fromValue(val))
    end

    def getRegValue(key)
      var = value(key)
      return var
    end

    def isRegExist(key)
      return !value(key).isNull
    end

  end
end
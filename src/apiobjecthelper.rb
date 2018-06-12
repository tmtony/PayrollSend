=begin
** Created: 2017/12/23
**      by: 金山软件--tmtony(王宇虹)
** Modified: 2018/01/18
**      by: 金山软件--tmtony(王宇虹)
**
** Description:Apiobjecthelper
=end
module SalaryMailPlugin
  class ApiObjectHelper
    def initialize
      @listApiobject = []

    end

    def addApi(apiObject)
      @listApiobject.push(apiObject)
    end

    def boardcastCustomMessage(func, para)
      p 'apiobjecthelper-boardcastCustomMessage'
      p func
      p para
      @listApiobject.each{|api|
        puts api
        p func
        p para
        api.callbackToJS(func, para)
      }
    end
  end
end
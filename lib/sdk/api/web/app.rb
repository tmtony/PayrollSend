=begin
  #--Created by caidong<caidong@wps.cn> on 2018/2/26.
  #--Description:下载接口
=end

module KSO_SDK::Web

  # JS下载接口
  class App < KSO_SDK::JsBridge

    public

    # 获取 AppType
    #
    def getAppType()
      json_result = {:app_type => KSO_SDK::getAppType }
      return json_result.to_json()
    end

    def bindingFile(filename)
      context.addBindingFile(filename)
    end

    def getAppInfo()
      json_result = {:app_type => KSO_SDK::getAppType, :script_id => context.scriptId, :app_id => context.appId, :title => context.title}
      return json_result.to_json()
    end

  end

end
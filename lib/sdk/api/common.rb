=begin
  #--Created by caidong<caidong@wps.cn> on 2018/2/26.
  #--Description:SDK核心组件类
=end
require 'win32ole'
require 'json'

require_relative 'event'
require_relative 'settings'
require_relative '../view'

module KSO_SDK

  public

  VERSION = '0.5.0'

  class GuideWidget < KSO_SDK::View::WebViewWidget

    def initialize(context, url)
      super(context)
      registerJsApi(Internal::Guide.new())
      showUrl(url)
    end

  end

  class App

    def initialize(context)
      @context = context
      @context.app = self
    end

    def context
      @context
    end

    def dispatchCreate(context, showGuide)
      newTaskPane(context) if @taskPane.nil?
      begin
        @isShowGuide = showGuide
        if showGuide
          showGuideWidget()
        else
          onCreate(context)
        end
      rescue Exception => e  
        klog e.message, *e.backtrace
      end

      bindPage(self) if context.bindPage
      bindLogout()
    end

    def setContentWidget(widget)
      @widget = widget
      @taskPane.setWidget(widget)
      @taskPane.refresh
    end

    def onCreate(context)
    end

    def onClose()
    end

    def setVisible(visible)
      @taskPane.setVisible(visible)
    end

    private 

    # 显示开屏动画页面
    def showGuideWidget()
      guideEntry = File.join(context.resPath, 'guide', 'index.html')
      raise "请将开屏动画页面放置在res/guide路径里，并提供index.html文件" unless File.exist?(guideEntry)
      guide = GuideWidget.new(context, guideEntry)
      setContentWidget(guide)
    end

    # 插件绑定文档
    def bindPage(app)
      return unless @bindEvent.nil?

      startedPage = KSO_SDK::activePage()
      return if startedPage.nil?
      bindFullName = startedPage.FullName
      app.context.addBindingFile(bindFullName)
      pageEvent = PageEvent.new()
      pageEvent.bindActive do | fullname |
        current = app.context.hasBindingFile(fullname)
        app.setVisible(current)
      end

      return if bindFullName.nil?
      pageEvent.bindClose startedPage do ||
        pageEvent.unbindActive()
        app.setVisible(false)
      end
      @bindEvent = pageEvent
    end

    # 注销重新跳会开屏页面
    def bindLogout
      KSO_SDK::getCloudService().connect Qt::SIGNAL('userInfoChange(int)') do
        showGuideWidget() if !KSO_SDK::logined? and !@isShowGuide
        @isShowGuide = true
      end
    end

    # 创建任务窗格
    def newTaskPane(context)
      @taskPane = KSO_SDK::View::TaskPane.new(context.title, KSO_SDK.getCurrentMainWindow(), context)
      @taskPane.onCloseClicked = lambda do
        klog "close"
        self.onClose()
      end
      @taskPane.setFeedbackUrl(context.feedbackUrl) unless context.feedbackUrl.nil?
      # dock pane
      KSO_SDK.getCurrentMainWindow().addDockWidget(Qt::RightDockWidgetArea, @taskPane, Qt::Horizontal)
      # pane 放到 taskpane 的左边
      taskpane_container = KSO_SDK.getCurrentMainWindow().findDockWidget("KxTaskPaneContainer")
      if !taskpane_container.nil?
        KSO_SDK.getCurrentMainWindow().splitDockWidget(@taskPane, taskpane_container, Qt::Horizontal)
        taskpane_container.setVisible(false)
      end
    end
    
  end

  class Context
  public
    attr_accessor :app

    def hasBindingFile(filename)
      return false if @binding_file_list.nil?
      @binding_file_list.each do |file|
        return true if file.eql?(filename)
      end
      return false
    end

    def addBindingFile(filename)
      return if hasBindingFile(filename)
      @binding_file_list = [] if @binding_file_list.nil?
      @binding_file_list << filename
    end

    def removeBindingFile(filename)
      return if !hasBindingFile(filename) || @binding_file_list.nil?
    end

  end

  # 插件启动入口
  def self.start(dir:, page:)
    context = newContext(dir, 'config.json')

    app = findApp(context)
    if !app.nil?
      app.setVisible(true)
      return
    end
  
    return nil if context.bindPage && activePage.nil?
    instance = page.new(context)
    registerApp(context, instance)
    instance.dispatchCreate(context, (!logined? || isFirstStart(context)))
  end

  # 获取存储文件夹
  def self.getStorageDir(context)
    dir = KingsoftDir
    Dir.mkdir(dir) unless File.exist?(dir)
    dir = File.join(dir, context.scriptId)
    Dir.mkdir(dir) unless File.exist?(dir)
    dir
  end

  # 获取宿主窗体
  def self.getCurrentMainWindow
    $kxApp.currentMainWindow
  end

  # 获取WPS 操作文档对象
  def self.getApplication
    Application
  end

  # 获取当前文档
  def self.activePage
    page = nil
    case AppType
      when :wps then page = Application.ActiveDocument
      when :et then page = Application.ActiveWorkbook
      when :wpp then page = Application.ActivePresentation
    end
    page
  end

  #添加当前插件到菜单栏
  def self.addFavorite(context)
    settings = Settings.new(context)
    settings.write(IsShowButton, 1) unless settings.keyExist?(IsShowButton)

    if @add_doc_tool_command.nil?
      @add_doc_tool_command = 
        KSO_SDK.getCurrentMainWindow().commands.findCommandByIdMso("AddDocumentToolCommand")
    end
    if !@add_doc_tool_command.nil?
      @add_doc_tool_command.setProperty("app_id", Qt::Variant::fromValue(context.scriptId))
      @add_doc_tool_command.trigger
    end
    nil
  end

  #从菜单栏中移除
  def self.removeFavorite(context)
    settings = Settings.new(context)
    settings.write(IsShowButton, 0) unless settings.keyExist?(IsShowButton)
  end

  # 获取context对应的插件对象
  def self.currentApp(context)
    @applist[context]
  end

  # 取消自启动
  def self.disableAutoStart(context)
    settings = Settings.new(context)
    settings.write(StartShow, false)
  end

  # :nodoc:
  def self.getCloudService
    $kxApp.cloudServiceProxy
  end

  # :nodoc:
  def self.getAppType
    AppType
  end

  # :nodoc:
  def self.isWps
    AppType == :wps
  end

  # :nodoc:
  def self.isWpp
    AppType == :wpp
  end

  # :nodoc:
  def self.isEt
    AppType == :et
  end

  private

  # :nodoc:
  Application = WIN32OLE::setdispatch(KxWin32ole::getDispatch)
  
  # :nodoc:
  AppType = $kxApp.applicationName.to_sym()

  # :nodoc:
  KingsoftDir = File.join(KxUtil.getOfficeHome, 'krubytemplate')

  ApplicationName = "application_name"
  Icon = "icon"
  IsShowButton = "is_show_button" # 添加到收藏
  RunFirst = "run_first" # 第一次启动
  StartShow = "start_show" # 是否自启动
  Title = "title"
  # 配置文件必填项
  RequireFields = [:appId, :scriptId, :appDb, :feedbackUrl, :feedbackUrl, :isDev, :bindPage, :title, :icon]

  # :nodoc:
  # 根据config.json生成context
  def self.newContext(dir, name)
    requireFields = RequireFields
    json = File.read(File.join(dir, name))
    json = JSON.parse(json)
    json['pluginPath'] = dir
    json['resPath'] = File.join(dir, 'res')

    requireFields.each do |field|
      raise "config.json 必须包含\"#{field.to_s}\"" unless json.has_key?(field.to_s)
    end

    context = Context.new()
    json.each do |key, val|
      context.define_singleton_method key do
        val
      end
    end
    context.define_singleton_method 'to_s' do 
      json.to_s
    end
    context
  end

  # :nodoc:
  # 注册插件
  def self.registerApp(context, app)
    initSettings(context)
    addApplist(context, app)
  end

  # 注册插件信息
  def self.initSettings(context)
    settings = Settings.new(context)
    settings.write(Title, context.title) unless settings.keyExist?(Title)
    settings.write(ApplicationName, "#{KSO_SDK::getAppType()}") unless settings.keyExist?(ApplicationName)
    settings.write(Icon, "#{File.join(context.resPath, context.icon)}") unless settings.keyExist?(Icon)
  end

  # 添加到插件列表
  def self.addApplist(context, app)
    @applist = {} if @applist.nil?
    @applist[context] = app
  end

  # 添加到插件列表
  def self.findApp(context)
    return nil if @applist.nil?
    @applist.each do |key, app|
      if key.appId == context.appId
        if context.bindPage
          return app if !KSO_SDK::activePage().nil? && app.context.hasBindingFile(KSO_SDK::activePage().FullName)
        else
          return app
        end
      end
    end
    return nil
  end

  # 插件是否第一次启动
  def self.isFirstStart(context)
    settings = Settings.new(context)
    return true unless settings.keyExist?(RunFirst)
    first = settings.readBool(RunFirst)
    klog "RunFirst = #{first}"
    first
  end

  # 设置第一次启动标识
  def self.setFirstStart(context, first)
    Settings.new(context).write(RunFirst, first)
  end

  # 是否登录
  def self.logined?()
    KSO_SDK::getCloudService.getUserInfo.logined
  end

end
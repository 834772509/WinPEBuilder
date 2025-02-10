App.ScriptEncoding = 'UTF-8'

is_pe = (os.info('isWinPE') == 1)  -- Windows Preinstallation Environment
is_wes = App:HasOption('-wes')         -- Windows Embedded Standard
is_win = App:HasOption('-windows')  -- Normal Windows

function App:Customization()
  -- 中文(Chinese): 设置 [我的电脑] - [属性] 菜单的处理方式
  -- English: Configure the action for [This PC] - [Property] menu

  -- 'auto', 'ui_systemInfo', 'system', '' or nil
  WxsHandler.SystemProperty = 'auto'

  -- 中文(Chinese): 设置 快捷方式 的 [打开文件所在位置] 菜单的动作函数
  -- English: Bind the function for shortcut's [OpenContainingFolder] menu

  -- nil or a handler function [  func(lnkfile, realfile)  ]
  -- WxsHandler.OpenContainingFolder = MyOpenContainingFolderHandler

  -- 中文(Chinese): 指定 当屏幕相关设定改变时触发的事件函数
  -- English: Specify the event function to be triggered when the screen related settings are changed
  -- WxsHandler.DisplayChangedHandler = MyDisplayChangedHandler

  -- 中文(Chinese): 设置 任务栏 时钟显示信息
  -- English: Set the display text of the taskbar clock
  -- WxsHandler.TrayClockTextFormatter = nil

  if os.info('locale') == 'zh-CN' then
    -- WxsHandler.TrayClockTextFormatter = TrayClockTextFormatter_zhCN
  elseif os.info('locale') == 'en-US' then
    -- WxsHandler.TrayClockTextFormatter = TrayClockTextFormatter_enUS
  end
end

function App:onLoad()
  -- App:Run('notepad.exe')
  print('WinXShell.exe loading...')
  print('CommandLine:' .. App.CmdLine)
  print('WINPE:'.. tostring(is_pe), 123, 'test', App)

  App:Customization()
end

function App:onDaemon()
end

function App:PreShell()
end

function App:onFirstShellRun()
end

function App:onShell()
  -- wxsUI('UI_WIFI', 'main.jcfg', '-notrayicon -hidewindow')
  -- wxsUI('UI_Volume', 'main.jcfg', '-notrayicon -hidewindow')
end

function App:onTimer(tid)
end

 -- a handler of OpenContainingFolder
function MyOpenContainingFolderHandler(lnkfile, realfile)
  -- local path = realfile:match('(.+)\\')
  App:Run('cmd', '/k echo ' .. realfile)

  -- totalcmd
  -- App:Run('X:\\Progra~1\\TotalCommander\\TOTALCMD64.exe', '/O /T /A \"' .. realfile .. '\"')
  -- XYplorer
  -- App:Run('X:\\Progra~1\\XYplorer\\XYplorer.exe', '/select=\"' .. realfile .. '\"')
end

-- 根据DPI自动切换屏幕分辨率
function MyDisplayChangedHandler()
  local cur_res_x = Screen:GetX()
  if last_res_x == cur_res_x then return end
  last_res_x = cur_res_x
  if last_res_x >= 3840 then
    Screen:DPI(150)
  elseif last_res_x >= 1440 then
    Screen:DPI(125)
  elseif last_res_x >= 800 then
    Screen:DPI(100)
  end
end

-- 自定义时钟区域的显示信息
-- 自定义显示示例:
--[[
    |  22:00 星期六  |
    |   2019-9-14    |
]]
-- FYI:https://www.lua.org/pil/22.1.html
function TrayClockTextFormatter_zhCN()
  local wd_name = {'日', '一', '二', '三', '四', '五', '六'}
  local now_time = os.time()
  local wd_disname =  ' 星期' .. wd_name[os.date('%w', now_time) + 1]
  local clocktext = os.date('%H:%M' .. TEXT(wd_disname) .. '\r\n%Y-%m-%d', now_time)
  App:SetVar('ClockText', clocktext)
end

-- custom tray clock display text
-- sample for:
--[[
    |  22:00 Sat  |
    |  2019-9-14  |
]]
-- FYI:https://www.lua.org/pil/22.1.html
function TrayClockTextFormatter_enUS()
  local now_time = os.time()
  local clocktext = os.date('%H:%M %a\r\n%Y-%m-%d', now_time)
  App:SetVar('ClockText', clocktext)
end

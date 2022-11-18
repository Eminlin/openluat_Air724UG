PROJECT = 'camera'
VERSION = '2.0.0'
require 'log'
LOG_LEVEL = log.LOGLEVEL_TRACE
require 'sys'

require "net"
--每1分钟查询一次GSM信号强度
--每1分钟查询一次基站信息
-- net.startQueryAll(60000, 60000)
--8秒后查询第一次csq
-- net.startQueryAll(8 * 1000, 60 * 1000)
--此处关闭RNDIS网卡功能
ril.request("AT+RNDISCALL=0,1")

-- sys.taskInit(function()
-- 	while true do
-- 		-- log.info('test',array)
-- 		log.info('Hello world!')
-- 		sys.wait(1000)
-- 	end
-- end)

require"myCamera"
require"mySocket"
require "ntp"
ntp.timeSync(24)

sys.init(0, 0)
sys.run()
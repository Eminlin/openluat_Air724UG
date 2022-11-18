require "socket"
module(..., package.seeall)

local ip, port, c = "x.x.x.x", "8080"

local asyncClient
sys.taskInit(function()
    while true do
        while not socket.isReady() do sys.wait(1000) end
        asyncClient = socket.tcp()
        while not asyncClient:connect(ip, port) do sys.wait(2000) end
        while asyncClient:asyncSelect() do end
        asyncClient:close()
    end
end)

-- 测试代码,用于发送消息给socket
function sendFile(size)
    sys.taskInit(
        function()
            while not socket.isReady() do sys.wait(2000) end
            local fileHandle = io.open("/testCamera.jpg","rb")
            if not fileHandle then
                log.error("sendFile open file error")
                return
            end
            log.info("-----------------------------------------------start send photo")
            asyncClient:asyncSend(size)
            while true do
                local data = fileHandle:read(size)
                if not data then break end
                asyncClient:asyncSend(data)
            end
            log.info("-----------------------------------------------end send photo")
            fileHandle:close()
        end
    )
    end

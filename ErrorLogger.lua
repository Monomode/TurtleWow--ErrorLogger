-- ErrorLogger (Turtle WoW 1.12)
-- Logs UI errors from macros/addons into SavedVariables

ErrorLoggerDB = ErrorLoggerDB or {}

-- Force-enable script errors
SetCVar("scriptErrors", 1)

-- Save old handler
local origHandler = geterrorhandler()

-- Our error handler
seterrorhandler(function(errMsg)
    local timestamp = date("%Y-%m-%d %H:%M:%S")

    -- Store error
    table.insert(ErrorLoggerDB, {
        time = timestamp,
        msg  = tostring(errMsg)
    })

    -- Also print to chat
    DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[ErrorLogger]|r " .. tostring(errMsg))

    -- Call original handler too
    if origHandler then
        origHandler(errMsg)
    end
end)

-- Slash command to show errors
SLASH_ERRORLOGGER1 = "/errors"
SlashCmdList["ERRORLOGGER"] = function()
    if #ErrorLoggerDB == 0 then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[ErrorLogger]|r No errors logged.")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[ErrorLogger]|r Showing last 5 errors:")
        for i = math.max(1, #ErrorLoggerDB - 4), #ErrorLoggerDB do
            local e = ErrorLoggerDB[i]
            DEFAULT_CHAT_FRAME:AddMessage("|cffffff00" .. e.time .. "|r " .. e.msg)
        end
    end
end

_G.accounts = require("accounts")
local chat = require("chat")

function _G.log(mode, text)
  if mode == 1 then
    local original_color = term.getTextColor()
    term.setTextColor(colors.gray)
    print("INFO: " .. text)
    term.setTextColor(original_color)
  elseif mode == 2 then
    local original_color = term.getTextColor()
    term.setTextColor(colors.white)
    print("WARNING: " .. text)
    term.setTextColor(original_color)
  elseif mode == 3 then
    local original_color = term.getTextColor()
    term.setTextColor(colors.red)
    print("ERROR: " .. text)
    term.setTextColor(original_color)
  end
end

parallel.waitForAll(table.unpack(chat.coroutines), accounts.main)
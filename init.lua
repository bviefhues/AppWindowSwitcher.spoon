--- === AppWindowSwitcher.spoon ===
---
--- Keyboard-driven Application Window Switcher.

require("hs.hotkey")
require("hs.window")
require("hs.inspect")
require("hs.fnutils")

local obj={}
obj.__index = obj

-- Metadata
obj.name = "AppWindowSwitcher"
obj.version = "0.0"
obj.author = "B Viefhues"
obj.homepage = "https://github.com/bviefhues/AppWindowSwitcher.spoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"


-- Variables --------------------------------------------------------

--- AppWindowSwitcher.logger
--- Variable
--- Logger object used within the Spoon. Can be accessed to set 
--- the default log level for the messages coming from the Spoon.
obj.log = hs.logger.new("AppWindowSwitcher")

function obj.startswith(text, prefix)
    return text:find(prefix, 1, true) == 1
end

function obj.match(window, matchtexts)
    bundleID = window:application():bundleID()
    if hs.fnutils.contains(matchtexts, bundleID) then
        obj.log.d("bundleID matches:", bundleID)
        return true
    end
    title = window:application():title()
    for _, matchtext in pairs(matchtexts) do
        if obj.startswith(title, matchtext) then
            obj.log.d("title matches:", title, matchtext)
            return true
        end
    end
    return false
end

--- AppWindowSwitcher:bindHotkeys(mapping) -> self
--- Method
--- Binds hotkeys for AppWindowSwitcher
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for each
---              application to manage, format per table element:
---
---              Either a single bundleID
---                 ["bundleID"] = {mods, key} 
---
---              Or a list of bundleIDs, to assign multiple applications 
---              to one hotkey.
---                 [{"bundleID", "bundleID", ...}] = {mods, key}
---
--- Returns:
---  * The TilingWindowManager object
function obj:bindHotkeys(mapping)
    for matchtexts, modsKey in pairs(mapping) do
        obj.log.d("Mapping " .. hs.inspect(matchtexts) .. 
                  " to " .. hs.inspect(modsKey))

        if type(matchtexts) == "string" then
            matchtexts = {matchtexts}
        end
        mods, key = table.unpack(modsKey)
        hs.hotkey.bind(mods, key, function() 
            local focusedWindowBundleID = 
                hs.window.focusedWindow():application():bundleID() 

            newW = nil
            if obj.match(hs.window.focusedWindow(), matchtexts) then
                -- app has focus, find last matching window
                for _, w in pairs(hs.window.orderedWindows()) do
                    if obj.match(w, matchtexts) then
                        newW = w -- remember last match
                    end
                end
            else
                -- app does not have focus, find first matching window
                for _, w in pairs(hs.window.orderedWindows()) do
                    if obj.match(w, matchtexts) then
                        newW = w
                        break -- break on first match
                    end
                end
            end
            if newW then
                newW:raise():focus()
            else
                hs.alert.show("No window open for " .. 
                    hs.inspect(bundleIDs))
            end
        end)
    end

    return self
end

--- AppWindowSwitcher:setLogLevel(level) -> self
--- Method
--- Set the log level of the spoon logger.
---
--- Parameters:
---  * Log level 
---
--- Returns:
---  * The AppWindowSwitcher object
function obj:setLogLevel(level)
    obj.log.setLogLevel(level)
    return self
end

return obj

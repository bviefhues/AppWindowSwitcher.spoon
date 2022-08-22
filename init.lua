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
    for bundleIDs, modsKey in pairs(mapping) do
        obj.log.d("Mapping " .. hs.inspect(bundleIDs) .. 
                  " to " .. hs.inspect(modsKey))

        if type(bundleIDs) == "string" then
            bundleIDs = {bundleIDs}
        end
        mods, key = table.unpack(modsKey)
        hs.hotkey.bind(mods, key, function() 
            local focusedWindowBundleID = 
                hs.window.focusedWindow():application():bundleID() 

            newW = nil
            if hs.fnutils.contains(bundleIDs, focusedWindowBundleID) then
                -- app has focus, find last matching window
                for _, w in pairs(hs.window.orderedWindows()) do
                    if hs.fnutils.contains(
                        bundleIDs,
                        w:application():bundleID()
                    ) then
                        newW = w
                    end
                end
            else
                -- app does not have focus, find first matching window
                for _, w in pairs(hs.window.orderedWindows()) do
                    if hs.fnutils.contains(
                        bundleIDs, 
                        w:application():bundleID()
                    ) then
                        newW = w
                        break
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

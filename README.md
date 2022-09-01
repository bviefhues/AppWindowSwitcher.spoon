# AppWindowSwitcher
---

macOS application aware, keyboard-driven window switcher. Spoon 
on top of Hammerspoon.

Cycles windows by focusing and raising them. All windows matching a 
bundelID, a list of bundleID's, an application name matchtext, 
or a list of application name matchtexts are cycled. Cycling applies 
to visible windows of currently focused space only. The spoon does 
not launch applications, it operates on open windows of running 
applications.

Example `~/.hammerspoon/init.lua` configuration:

```
hs.loadSpoon("AppWindowSwitcher")
    -- :setLogLevel("debug") -- uncomment for console debug log
    :bindHotkeys({
        ["com.apple.Terminal"]        = {hyper, "t"},
        [{"com.apple.Safari",
          "com.google.Chrome",
          "com.kagi.kagimacOS",
          "com.microsoft.edgemac", 
          "org.mozilla.firefox"}]     = {hyper, "q"},
        ["Hammerspoon"]               = {hyper, "h"},
        ["O", "o"]                    = {hyper, "o"},
    })
```
In this example, 
* `hyper-t` cycles all terminal windows (matching a single bundleID),
* `hyper-q` cycles all windows of the four browsers (matching either 
  of the bundleIDs)
* `hyper-h` brings the Hammerspoon console forward (matching the 
  application title),
* `hyper-o` cycles all windows whose application title starts 
  with "O" or "o".

Windows maintain an order on the desktop, they are stacked. 
The cycling logic works as follows:
* If the focused window is part of the application matching a hotkey,
  then the last window (in terms of stacking) of the matching 
  application(s) will be brought forward and focused.
* If the focused window is not part of the application matching a
  hotkey, then the first window of the matching applications will be
  brought forward and focused.

## API Overview
* Methods - API calls which can only be made on an object returned by a constructor
 * [bindHotkeys](#bindHotkeys)
 * [setLogLevel](#setLogLevel)

## API Documentation

### Methods

| [bindHotkeys](#bindHotkeys)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `AppWindowSwitcher:bindHotkeys(mapping) -> self`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Binds hotkeys for AppWindowSwitcher                                                                     |
| **Parameters**                              | <ul><li>mapping - A table containing hotkey modifier/key details for each application to manage</li></ul> |
| **Returns**                                 | <ul><li>The AppWindowSwitcher object</li></ul>          |
| **Notes**                                   | <ul><li>The mapping table accepts these formats per table element:</li><li>* A single text to match:</li><li>  `["<matchtext>"] = {mods, key}` </li><li>* A list of texts, to assign multiple applications to one hotkey:</li><li>  `[{"<matchtext>", "<matchtext>", ...}] = {mods, key}`</li><li>* `<matchtext>` can be either a bundleID, or a text which is substring matched against a windows application title start. </li></ul>                |

| [setLogLevel](#setLogLevel)         |                                                                                     |
| --------------------------------------------|-------------------------------------------------------------------------------------|
| **Signature**                               | `AppWindowSwitcher:setLogLevel(level) -> self`                                                                    |
| **Type**                                    | Method                                                                     |
| **Description**                             | Set the log level of the spoon logger.                                                                     |
| **Parameters**                              | <ul><li>Log level - `"debug"` to enable console debug output</li></ul> |
| **Returns**                                 | <ul><li>The AppWindowSwitcher object</li></ul>          |
| **Notes**                                   | <ul></ul>                |


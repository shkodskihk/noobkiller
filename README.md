skoope
======

Utility for Skype made in Lua.
Lua communication with Skype is set through Microsoft COM interface.

## Usage ##

LuaJIT and modules are included in this repo, just start launch-skoope.cmd to get this working.

## Scripting ##

For your convenience I'd suggest you to put your scripts in *lua/addons* folder.
Addons get autloaded right after core modules become ready.

### Hooks ###

Main thing in skoope is hook system. It's similar to hook thingy you'd meet in Garry's mod

```lua
hook.Add(HookName, HookID, Function)
hook.Remove(HookName, HookID)
local ret = {hook.Call(HookName, ...)}
```

Every tick *Think* hook gets called. Tick is one iteration of *while* loop. Basically, while loop is something like this:

```lua
while 1 do
	hook.Call("Think")
	sleep(0.01)
end
```

Sleep time is configured through *config.lua*.

There is already some hooks which can help you in interaction with Skype.

**PersonSay**(senderObj, messageString, messageObj) — occurs every time when someone says something somewhere. See Skype4COM.chm to get more information about sender and message objects.
**AuthRequest**(userObj, requestString) — occurs when someone sends you a contact info request.

### Timers ###

You can delay/make repeatable function execution by using timers. It's pretty much easy to use them.

```lua
timer.Simple(delay, func) -- executes function with certain delay
timer.Create(name, delay, numberOfRepeats, func) -- numberOfRepeats set to 0 makes timer run forever (as long as main process is alive)
timer.Remove(name) -- removes timer
```

## Running in Sandboxie ##

Afaik, COM can interact with applications running in sandboxie, so you should have no problem using skoope with it.

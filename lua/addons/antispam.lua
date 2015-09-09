local Settings = {
    ["ranked"] = {
        ["jack.fox94"] = {Rank = 4, Desc = "Creator of the bot"},
        ["live:wmaduno"] = {Rank = 4, Desc = "Creator of the bot"},
    },
    ["rankedlist"] = {
        [0] = "Guest",
        [1] = "Member",
        [2] = "Moderator",
        [3] = "Administrator",
        [4] = "Creator"
    },  
    ["botname"] = "Jack Bot",
    ["prefix"] = "!",
    ["suffix"] = " "
}
local Commands = {}

local function Chat(mobj,Message)
    print(mob,Message)
    mobj.Chat:SendMessage("[" .. Settings["botname"] .. "]: " .. Message)
end

local function GetSettings(user)
    local s = Settings["ranked"][user]
    if not s then
        Settings["ranked"][user] = {Rank = 0, Desc = "Default, no rank"}
        s = Settings["ranked"][user]
    end
    return s
end

local function Chatted(mobj,msg,speaker)
    local prefix,suffix = Settings["prefix"],Settings["suffix"]
    if msg:sub(1,#prefix) ~= prefix then return end
    msg = msg:sub(#prefix+1)
    local args = ""
    local mfind = msg:find(suffix)
    if mfind then
        args = msg:sub(mfind+#suffix)
        msg = msg:sub(1,mfind-1)
    end
    if msg == "" then return end
    local cmdfound
    local settings = GetSettings(speaker)
    for k,v in pairs(Commands) do
        if cmdfound then break end 
        table.foreach(v.Calls,function(self,index)
            if index == msg then
                cmdfound = true
                if settings["Rank"] >= v.Rank then
                    local newthread = coroutine.create(v.Func)
                    print(newthread)
                    local thread_check = {coroutine.resume(newthread,mobj,args,speaker)}
                    print(unpack(thread_check))
                    if not thread_check[1] then
                       return Chat(mobj,string.format("Error: %s",thread_check[2]))     
                    end
                else
                    return Chat(mobj,string.format("You are not a high enough rank for this command, %s",mobj.FromDisplayName))
                end
            end
        end)
    end
    if not cmdfound then
        return Chat(mobj,string.format("Sorry %s, Command %s not found",mobj.FromDisplayName,msg))
    end
end

local function CreateCmd(Name,Calls,Desc,Rank,Func)
   Commands[Name] = {Name = Name,Calls = Calls, Desc = Desc, Rank = Rank, Func = Func} 
end

CreateCmd("Test",{"test","testing","tests","testz"},"Tests the bot",0,function(mobj,args,speaker)
    Chat(mobj,string.format("Test completed, %s",mobj.FromDisplayName))    
end)

CreateCmd("Kick",{"k","kick","kek","kix"},"Kicks the player(s) from the group",3,function(mobj,args,speaker)
        
end)

CreateCmd("Add",{"addp","addperson","add","addcontact","addc"},"Adds the player to the group",3,function(mobj,args,speaker)
    Chat(mobj,string.format("%s, Added user %s",mobj.FromDisplayName,args))
    pcall(function() mobj.Chat:SendMessage(string.format("/add %s",args)) end)
end)

CreateCmd("Mute",{"mute","mt"},"Mutes the user(s) in the group",2,function(mobj,args,speaker)
        
end)

CreateCmd("Unmute",{"unmute","umute","umt","unmt"},"Unmutes the user(s) in the group",2,function(mobj,args,speaker)
        
end)



hook.Add("PersonSay", "AntiSpam", function(sender, message, mobj)
    Chatted(mobj,message,mobj.FromHandle)
end)

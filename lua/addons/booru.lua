require"luaxml"
local json=require"json"

local ratings = {s='safe',q='nsfw?!',e='nsfw'}

hook.Add("PersonSay", "Gelbooru", function(pl, line, msg)
	for id in line:gmatch("https?://%w*.?gelbooru%.com/[%w%p]*&id=(%d+)") do
		luasocket.Get("http://gelbooru.com/index.php?page=dapi&s=post&q=index&id=" .. id, function(t)
			local data = xml.eval(t.content)[1]
			msg.Chat:SendMessage(	"[Gelbooru] " .. ratings[data.rating] .. ' ' .. data.width..'x'..data.height .. "\n" ..
					"Tags: " .. data.tags
			)
		end)
	end

	for id in line:gmatch("https?://%w*.?e621%.net/post/show/(%d+)/") do
		luasocket.Get("http://e621.net/post/show.json?id=" .. id, function(t)
			local data = json.decode(t.content)
			msg.Chat:SendMessage(	"[e621] " .. ratings[data.rating] .. ' ' .. data.width..'x'..data.height .. "\n" ..
					"Tags: " .. data.tags
			)
		end)
	end
end)
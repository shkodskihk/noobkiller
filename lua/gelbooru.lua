require"luaxml"

local ratings = {s='safe',q='nsfw?!',e='nsfw'}

hook.Add("PersonSay", "Gelbooru", function(pl, line)
	for id in line:gmatch("https?://%w*.?gelbooru%.com/[%w%p]*&id=(%d+)") do
		luasocket.Get("http://gelbooru.com/index.php?page=dapi&s=post&q=index&id=" .. id, function(t)
			local data = xml.eval(t.content)[1]
			Say(	"[Gelbooru] " .. ratings[data.rating] .. ' ' .. data.width..'x'..data.height .. "\n" ..
					"Tags: " .. data.tags
			)
		end)
	end
end)
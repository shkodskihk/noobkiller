local json=require"json"
local usr="Last.fm login here"
local apikey="" -- you'll need your own last.fm api key!!!

timer.Create("lastfm", 5, 0, function()
	luasocket.Get("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=".. usr .."&limit=1&api_key=".. apikey .."&format=json", function(t)
		local track = json.decode(t.content).recenttracks.track[1]
		if track and track["@attr"].nowplaying then
			skype.CurrentUserProfile.MoodText = "Skoope\\Last.fm: " .. track.artist["#text"] .. " - " .. track.name
		end
	end)
end)
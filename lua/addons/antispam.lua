hook.Add("PersonSay", "AntiSpam", function(sender, message, mobj)
	    print("sender", sender, type(sender))
	    print("message", message, type(message))
	    print("message obj", mobj, type(mobj))

	    table.foreach(sender, print)

	    print("-------------")

	    table.foreach(mobj, print)
	    skype:SendMessage(sender.Handle, "aloaLolaOlalLaLl -Diitto; ".. message)
	    print("skype: ", skype, type(skype))
end)


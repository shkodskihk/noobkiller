hook.Add("PersonSay", "AntiSpam", function(sender, message, mobj)
	    print("sender", sender, type(sender))
	    print("message", message, type(message))
	    print("message obj", mobj, type(mobj))

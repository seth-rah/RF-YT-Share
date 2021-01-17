import validators
import re

regex = re.compile("youtu(?:.*\/v\/|.*v\=|\.be\/)([A-Za-z0-9_\-]{11})")

def URLDefine():
	validate = input("Provide a youtube URL or leave blank for the default: ")
	if len(validate) > 0:
		ValidURL = validators.url(validate)
		if ValidURL==True and regex.search(validate):
			print("Valid URL Provided")
			return validate
		else:
			print("URL provided is not a valid youtube video")
			URLDefine()
	else:
		return "https://www.youtube.com/watch?v=SY3y6zNTiLs"

URL = URLDefine()
from robot.api import logger

def List_To_String_Compare(String, List):
	logger.console("\n----------==========={( COMPARE LIST CONTENTS TO STRING )}===========----------\n")
	Result = False
	AdjustedList = [Entry for Entry in List if len (Entry) > 1]
	for i in AdjustedList:
		if i in String:
			Result = True
			logger.console("List entity: '" + i + "' was found in string content '" + String + "'")
	logger.console("\n")
	return Result
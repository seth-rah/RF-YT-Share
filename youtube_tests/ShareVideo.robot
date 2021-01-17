*** Settings ***

Documentation     The primary file executing test cases by calling upon keywods from different resources.

Library          	SeleniumLibrary

#									Allows for user input of URL before test case execution with added validation.
Variables					YoutubeVariables.py

Resource					YoutubeProcesses.robot
Resource					Resources.robot

*** Variables ***

${Browser}        			Chrome
${Delay}          			0
# ${URL}								https://www.youtube.com/watch?v=SY3y6zNTiLs
#												User defined value at the start of script execution from YoutubeVariables.py
# 											To skip entering a URL manually at the start of script execution Comment out the 
#												YoutubeVariables.py resource and define a URL here under Variables.

*** Test Cases ***

Share Video Desktop
    Open Desktop Browser To URL
		Validate Webpage
		Validate Video Availability
		Click Share Button
		Copy Desktop Share URL
		Open Share URL In New Tab
		Validate Webpage
		[Teardown]							Close Browser

Share Video Mobile
		Open Mobile Browser To URL
		Validate Webpage
		Validate Video Availability
		Click Share Button
		Copy Mobile Share URL
		Open Share URL In New Tab
		Validate Webpage
		[Teardown]							Close Browser

Share Video Desktop Timestamped
    Open Desktop Browser To URL
		Validate Webpage
		Validate Video Availability
		Click Share Button
		Copy Timestamped Share URL
		Open Share URL In New Tab
		Validate Webpage
		[Teardown]							Close Browser
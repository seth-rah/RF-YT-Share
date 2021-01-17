*** Settings ***

Documentation     Collection of keywords that serve functionality on the YouTube platform.

Resource					Resources.robot

#									Library is used to gain access to the windows clipboard.
#									Library requires Microsoft Visual C++ 14.0 or greater. Get it with "Microsoft C++ Build Tools": https://visualstudio.microsoft.com/visual-cpp-build-tools/
#									Keep default configuration when installing. Do not run pip install through powershell. CMD as administrator is required.
#									If more errors occur, compile the following yourself https://cryptography.io/en/2.9.2/installation/ && https://cryptography.io/en/2.9.2/faq/
#									Does not work with Pyhton 3.9 https://github.com/mhammond/pywin32/issues/1593, Python 3.8 is advised.
Library						RPA.Desktop

*** Keywords ***

Click Share Button
		[Documentation]										Initially @aria-label was thought to be a consistent attribute in mobile and desktop view share buttons. 
		...																Unfortunately it appears that this attribute can be stripped from mobile page view load under unknown circumstances.
		...																Checks to see if the share button is visible on a YouTube page and clicks if when available.
		Wait Until Element Is Visible			xpath://*[contains(local-name(), 'button')]//*[contains(text(), 'Share')][not (contains(@class, 'ytp-share-title'))]		10
		Click Element											xpath://*[contains(local-name(), 'button')]//*[contains(text(), 'Share')][not (contains(@class, 'ytp-share-title'))] 

Copy Desktop Share URL
		[Documentation]										Action a click against the copy button provided by YouTube to add the share URL to clipboard, and then store the value.
		Wait Until Element Is Visible			xpath://*[@id="copy-button"]						10
		Click Element											xpath://*[@id="copy-button"]
		${ShareURL} =											Get Clipboard Value
		Set Global Variable								${ShareURL}															${ShareURL}

Copy Mobile Share URL
		[Documentation]										Copy the URL value for the YouTube share URL through xpath, as mobile does not have a copy function to make use of.
		Wait Until Element Is Visible			xpath://*[@class="unified-share-url"]		10
		${ShareURL} = 										Get Text																xpath://*/a[@class="unified-share-url"]
		Set Global Variable								${ShareURL}															${ShareURL}

Copy Timestamped Share URL
		[Documentation]										Action a click against the "Start at" field in the sharebox, as well as updating the timestamp, followed by clicking the copy button.
		[Arguments]												${Timestamp}=0:10
		Wait Until Element Is Visible			xpath://*[@id="copy-button"]						10
		Click Element											xpath://ytd-unified-share-panel-renderer//div[@id="checkboxContainer"]
		Input Text												xpath://ytd-unified-share-panel-renderer//input[@class="style-scope paper-input"]						${Timestamp}								clear=true
		Click Element											xpath://*[@id="copy-button"]
		${ShareURL} =											Get Clipboard Value
		Set Global Variable								${ShareURL}															${ShareURL}

Open Share URL In New Tab
		[Documentation]										Open a new tab using Javascript at the provided URL
		Execute Javascript   							window.open('${ShareURL}');
		Sleep															3

Validate Video Availability
		[Documentation]										Validates if the video is legible for playback and sharing. 
		...																Private video https://www.youtube.com/watch?v=bXiW3BDoDuc
		...																Video with age restriction https://www.youtube.com/watch?v=XnskXdZhihM
		...																Non-available videos can be accessed by fooling around with characters in the URL v element.
		...																Region locked video, at least in south africa and the US https://www.youtube.com/watch?v=Jc1EOTFT1zU
		...																Sleep is added to give the page time to process everything it needs to before it would normally display the message.
		Sleep															3
		Element Should Not Be Visible			xpath://*[@id="reason"]|//*[@class="playability-status-message playability-reason"]

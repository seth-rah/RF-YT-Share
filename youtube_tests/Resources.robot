*** Settings ***

Documentation     Resources to be used for cleaner test case execution.

Library						String
Library						Comparisons.py

*** Keywords ***

Open Mobile Browser
		[Documentation]				Currently only supports chrome browser because of supplied arguments. Requires expansion.
		...										Be sure to capitalize browsers correctly, as selenium handles interpreting the webdriver creation.
		...										Altering device name is advised against, but possible.
    [Arguments]						${URL}=https://www.youtube.com/watch?v=SY3y6zNTiLs							${DeviceName}=iPhone 5/SE		${Browser}=Chrome
    ${Device}=						Create Dictionary							deviceName=${DeviceName}
		${Exclude}    				Create list     							enable-logging
    ${Options}=						Evaluate											sys.modules['selenium.webdriver'].ChromeOptions()							sys, selenium.webdriver
    Call Method						${Options}										add_experimental_option						mobileEmulation							${Device}
		Call Method    				${Options}    								add_experimental_option						excludeSwitches							${Exclude}
		# Call Method					${Options}										add_argument											--headless
    Create Webdriver			${Browser}										options=${Options}
    Goto    							${URL}

Open Desktop Browser
		[Documentation]				Currently only supports chrome browser because of supplied arguments. Requires expansion.
		...										Be sure to capitalize browsers correctly, as selenium handles interpreting the webdriver creation.
		...										Created in order to feed more arguments to the normal Open Browser keyword such as cleaning up the logs.
    [Arguments]						${URL}=https://www.youtube.com/watch?v=SY3y6zNTiLs							${Browser}=Chrome
		${Exclude}    				Create list     							enable-logging
    ${Options}=						Evaluate											sys.modules['selenium.webdriver'].ChromeOptions()							sys, selenium.webdriver
		Call Method    				${Options}    								add_experimental_option						excludeSwitches							${Exclude}
		# Call Method					${Options}										add_argument											--headless
    Create Webdriver			${Browser}										options=${Options}
    Goto    							${URL}

Open Desktop Browser To URL
		[Documentation]				Opens a web browser that renders desktop web pages with the provided URL
		Open Desktop Browser	${URL}
    Set Selenium Speed    ${Delay}

Open Mobile Browser To URL
		[Documentation]				Opens a web browser that renders mobile web pages with the provided URL
    Open Mobile Browser 	${URL}
    Set Selenium Speed 		${Delay}

Sanitize URL
		[Documentation]				Removes the from of any given URL as well as removing symbols from the URL to assist in comparisons.
		${CleanURL} =					Replace String Using Regexp		${URL}														((^https?)|(www\.)|([^A-Za-z0-9]))											${EMPTY}
		${LowerURL} =					Convert To Lower Case					${CleanURL}
		Set Global Variable		${LowerURL}										${LowerURL}

Sanitize Page Title
		[Documentation]				Splits different words in a page title into a list for comparison sake.
		${Title} =						Get Title
		${CleanTitle} =				Replace String Using Regexp		${Title}													((^https?)|(www\.)|([^A-Za-z0-9 ]))											${EMPTY}
		${LowerTitle} = 			Convert To Lower Case					${CleanTitle}
		${TitleList} =				String.Split String						${LowerTitle}											${SPACE}
		Set Global Variable		${TitleList}									${TitleList}

Compare Title To URL
		[Documentation]				In theory most webpages contain part of their URL in the title. 
		...										This Keyword is used to validate that the URL provided is opening the correct page and not being redirected to another domain.
		...										2 characters or more need to be included in the title to ensure that shorter site names are supported such as xe.com
		Sanitize URL
		Sanitize Page Title
		${Result} =						List To String Compare				${LowerURL}												${TitleList}
		Should Be True				${Result}

Validate Webpage
		[Documentation]				Currently checks that a word in the title with 2 characters or more matches part of the URL Variable
		...										Can be expanded on further to be more verbose and robust.
    Compare Title To URL
# Robot Framework Youtube Assignment
A short demonstration of sharing youtube videos and content validation.

## Pre-requisites
1. Windows 10 64bit
2. [Python 3.8](https://www.python.org/downloads/release/python-387/) and not later.
3. [Pip](https://pip.pypa.io/en/stable/installing/) for easy installation of requirements.
4. [Chromedriver](https://chromedriver.chromium.org/downloads) that has been added to your [PATH environment variables](https://chromedriver.chromium.org/getting-started). For information on how to do that, [click here](https://helpdeskgeek.com/windows-10/add-windows-path-environment-variable/).
5. [C++ Build Tools 14.0 or higher](https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=BuildTools&rel=16) including 2 optional packages (MSVC 142 or later and Windows 10 SDK 10.0.18362.0 or later)
6. [Win64 OpenSSL v1.1.1i](https://slproweb.com/products/Win32OpenSSL.html)

## Installation

After installation of all the prerequisites and downloading of this project, navigate a CMD terminal as admin to the projects extracted directory.

Unfortunately Powershell does not interpret one of the requirement installations gracefully so using it is advised against. This is due to the Cryptography library included in the RPAFramework package not interacting nicely with Powershell. 

To provision the project, run `pip install -r requirements.txt --no-cache-dir` in the CMD terminal. If Cryptography runs into installation errors, then either a prerequisite has not been correctly installed, or cryptogrophy requires some additional steps to be performed during the installation process before it's able to build correctly.

For more information [click here](https://cryptography.io/en/2.9.2/installation/#building-cryptography-on-windows). Please note that the commands shown on this page only function in CMD and not in Powershell. The directories shown during the set process will be your installtion directory for pre-requisite 5. Please remember to use quotes if the directory includes spaces where necessary.

If some problems are still experienced with cryptography please have a look at the [FAQ](https://cryptography.io/en/2.9.2/faq/) and verify that your python version [is not 3.9](https://github.com/mhammond/pywin32/issues/1593) because of an import issue that's still experienced with the latest stable build.

Once a `pip install -r requirements.txt --no-cache-dir` completes  without errors, then the project is ready to be used.

To verify that everything is prepared, run `robot --version` to see if a positive response is returned.

## How to run

Starting the test suite is as simple as running `robot /path/to/youtube_tests`

You'll be provided with the oppurtunity to feed a youtube video URL on script execution which will be used to run the test cases.

### Test Case Rundown

1. The first process validates that the URL provided is indeed a YouTube video URL by using regular expression to see if it matches the current standard for video URL's. Youtube has stated that they can not confirm that this standard won't change in the future. The URL provided at the start is stored as a global variable and won't change throughout the course of the test suite execution.

2. With a URL available, a custom webdriver is created for chrome to test against a Desktop and a Mobile use case. Because of this Chrome is currently the only supported browser. There is a known issue with my webdriver configuration that will not open newtabs on the mobile configuration in the mobile viewport. Thankfully for this use case the differences that mattered are on the initial tab.

3. Once the page has finished loading in the browser, a comparison is run against the URL and the page title. It checks to see if any word within the title that is 2 characters or longer can be matched back to the URL. This is to make sure that a redirect does not occur to a different domain on page load. \
The thought process here is that a large majority of web pages have some common element in the title that is included in the URL and sometimes it's split through non alphanumeric characters in the URL like youtu.be. \
Because of this we strip the URL of its scheme and symbols to have a simpler value to compare against. The reason 2 characters were used and not more is for the logic to be more universal in circumstances such as xe.com. Although in hindsight changing the character match count to be a function argument might have been a better idea.

4. With youtube content policies not always being consistent across different regions, or links not always being accessible because of visibility settings and age restrictions, a check is done on the page to see if a common error element is loaded that's been consistent across all my tests so far. If the element is not visible, then the test can continue.

5. With the page loaded a wait is actioned for the share button to appear as our error checks have passed. under normal circumstances the button should exist and therefor if it's not available yet, then there is the chance that it has not rendered yet. The button will be clicked on as soon as available, but if it does not show up within 10 seconds then the test is failed as something else might be wrong.

6. Optionally youtube allows a video to be started at a given timestamp when sharing a video from a Desktop browser. The button is clicked, the input for the start time is cleared and replaced with a value at default or provided as an argument to the keyword. On Desktop there is a copy button that will add the share URL to clipboard when selected which will be selected with or without the timestamp depending on the keyword. Once added to clipboard, the clipboard content is stored as a global variable to be accessed again later. \
With the mobile view of YouTube the layout of the page is adjusted and there is no access to a copy button. Because of this a different keyword is used for mobile layout to get access to the share URL. Once acquired it's also stored into a global variable.

7. To open a new tab with the share URL, I invoke the javascript to open a new browser window with the stored share URL. I was not able to find any native robot framework functions for this task and went with this approach. 

8. Lastly we run another check on the new tab that was opened to see if we're still on youtube after selecting the share url. Some additional work can be done here to validate the video ID matching the one opened at the start of script execution.


## Afterword

### Oversights

While writing this README I noticed that I don't clear the ${ShareURL} after each test case, which can lead to invalid test results.

As mentioned in step 8 I have room to improve the validation on the URL opened in the new tab by using regular expression to match the share URL to the initial URL to see if their video ID's match. 

### Comments

Firstly apologies for the delays. Inbetween the surgery and the power cuts I had a bit of a rough start trying to get my environment up and running. There was a lot of troubleshooting involved with the versions I was using and the library I was planning to use to retreive clipboard content.

I will say that over the last few days I have grown more comfortable with python and the robot framework but with all the troubleshooting that I had to go through I didn't have enough time on hand to containerize the test suite. I was planning to use Docker, but my environment I am using to write this from isn't suitable to run docker. 

I tried to bring up a virtual machine with Ubuntu Desktop to get everything containerized but noticed that the environment setup isn't the same as it was on Windows, so I unfortunately wasn't able to get that operational in time.

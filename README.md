# Radium Desktop

The app is written in Flex 3 using the RobotLegs framework with AS3Signals. User interactions dispatch signals, which
are mapped to the appropriate commands, and the state of the application is being stored in the main model class.


## Classes

### Default Package

**ApplicationContext**

Initializes the framework and maps the signals to the appropriate commands.


**ApplicationMediator**

Mediator for the main application class. Sets the auto updater, listens to signals and updates the main view accordingly.



### com.radium.crm.model

**ContentModel**

Stores the state of the application.

**Constants**

Contains all the important constant values such as URLs, error messages, API calls and paths to log files.


### com.radium.crm.remote.services

**AuthenticationService**

Handles the user authentication.

**LogService**

Filters the new call and SMS log data and sends it to the Radium server. Also handles error reporting.


### com.radium.crm.utils

**ConnectionMonitor**

Monitors the user's internet connection and dispatches a signal whenever the connection is lost or restored.

**ErrorManager**

Keeps track of the application errors. The class keeps all the current error messages in a stack, so whenever an error
is resolved it automatically displaye the next one.

**SyncMonitor**

Locates the backup files on the user's computer and handles the automatic logging when it detects a device has been
synced.

**VOParser**

Parser the JSON formatted server responses into value object files.


## User data

User credentials are saved in encrypted local storage along with the user's preferred server URL. Settings and log history
are saved in unencrypted XML files in the application storage directory.


## Compilation

Compiled either in Flash Builder or an external IDE (Eclipse, FlashDevelop, FDT...) with Flex 3 SDK. The descriptor
file and the "data" folder must be included in the exported AIR file.

The following libraries must be included in the library path:

* [Robotlegs v1.3.0](http://robotlegs.org)
* [AS3 Signals v0.5](https://github.com/robertpenner/as3-signals)
* [SignalsCommandMap](https://github.com/joelhooks/signals-extensions-CommandSignal)
* [AS3 Corelib](https://github.com/mikechambers/as3corelib)
* [Greensock](http://www.greensock.com)
* ApplicationUpdater (included in the AIR SDK)

## Auto update

The current version number is specified in the application descriptor file (Main-app.xml). The update XML file
on the server needs to have the most up to date version number along with the version description. The update
file is found at http://downloads.radiumcrm.com/radium_desktop/update.xml. When running the auto update the 
application checks the current version number against the update file and updates itself in case the one on the 
server is newer.

The attributes of the updates are defined in com.radium.crm.ApplicationMediator. The following attributes can
be set to true or false:

* isCheckForUpdateVisible
* isInstallUpdateVisible
* isDownloadUpdateVisible
* isFileUpdateVisible
* isDownloadProgressVisible
* delay (the number of days between auto update checks)

## Packaging

Installer bundle

We are distributing an installer package that installs both Radium Desktop and Adobe AIR on the user's machine.
While the same AIR file can be installed on any platform, the installer bundle has to be packaged separately for
Windows and OSX.

Instructions on how to do this: http://help.adobe.com/en_US/air/redist/WS485a42d56cd19641-70d979a8124ef20a34b-8000.html

## HTML badge

The bundle can also be installed via a browser link. 

Instructions on how to do this: http://www.adobe.com/devnet/air/articles/air_badge_install.html

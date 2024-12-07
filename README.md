# FlutterFitness

A beautiful Material Design fitness tracking app made in Flutter. Tracks your running and walking activity. Comes with a self-hosted server option for privacy of your data.

## Screenshots

TODO
A very short video demo is available here (TODO link)

## Features
 - Accounts for personal logins and stats tracking
 - Integrated maps and graphs for visualisation
 - Hybrid local and server storage capabilities for times without internet access
 - Nearby users finder (with a client-side killswtich for privacy)
 - Weekly leaderboards tracking a number of stats and demographics
 - User friending system
 - Dark mode support
 - Saved run history
 - Custom icons and animations throughout the app

## Getting Started
There are 2 main options for running the app.
1. Using the precompiled apks available for Android. You can access these either from the GitHub releases tab or from the build artifacts published on [Azure Pipelines](https://dev.azure.com/muzammilahmad/FlutterFitness/_build)
2. Compiling yourself - you can host your own server or use the provided one

### Compiling the application
Make sure you have a Flutter development environment set up. If not, you can visit the [official guide](https://docs.flutter.dev/get-started/install). This project has been tested to work with Flutter versions `3.10.0` and `3.11.0-0.1.pre`.

#### Setting up Google Maps
You will need a Google Maps API key for the Google Maps components to work in the app. The Google Maps SDK is free to use on Android and IOS. 

To use your key when compiling, create a file named `.env` and set its contents to be 
```bash
gmap_api_key=YOUR_API_KEY
```  
Where `YOUR_API_KEY` is your api key (without any quotations marks).

Alternatively, if using Azure Pipelines, you can set the variable `gmap_api_key` from the pipeline editor window to your API key and the pipeline will automatically inject it.

#### Running the code
After opening a terminal in the root folder of the project run the following:
1. `flutter clean` (optional)
2. `flutter pub get` to fetch the required packages
3. Now based on whether you want an optimised final version or a debug version of the app there are 2 option:
    * If you want to build a final version of the app for use or distribution, run `flutter build apk --release` to build for android or `flutter build ios --release` for ios
    * To create a debug version of the app on a device of your choice use `flutter run`

#### Setting up the server
The app includes a Python flask server to handle data requests. You can choose to host your own server or use one hosted by me.
If using the pre-hosted server, no changes are required and you can skip this section.
1. Clone this repo (or download the contents of the server folder) onto the machine you want to use as the server
2. (Ideally do this in a virtual environment) Run `pip install -r ./FlutterFitness/server/requirements.txt` to install the required dependencies
3. Start the server. You can choose what WSGI server you want to use. Some examples of commands you can use to start the server on port 8080 are `flask --app server.py  run --host=0.0.0.0 -p 8080 or gunicorn` and `gunicorn --bind 0.0.0.0:5000 server:app`
4. Note the IP of the machine running the server
    * If you would like a server accessible from anywhere on the internet, you will likely need to forward the correct port and then note down the public IP address of the server machine. Forwarding ports to the internet comes with inherent risks, so make sure you research before changing any settings on your router or cloud provider, since if done incorrectly/carelessly can expose your machine to the internet unprotected.
5. You will also need to specify your server within the app. You can do this from the top right-hand side of the login screen. Ensure you include any protocols and ports within the specified URL. If you would like to use the pre-hosted server, no changes are required. 
    * To switch back to the pre-hosted server at any time, change the server to `http://flutterfitness.hscscalinggraphs.au:8080`

## Other Notes
The vast majority of the icons used in the app were created by me. They have been included as a font in the assets folder.

Within the server folder you will find some basic tests that can be run with a self-hosted server using the insomnia API client. Make sure the server does not have any pre-existing data or these tests will fail.

You will find that there are references to an app called "runfun" throughout the packages, this was a previous name for the app. The package names were not updated.
# FlutterFitness

A beautiful Material Design fitness tracking app made in Flutter. Tracks your running and walking activity

## Screenshots

TODO

## Getting Started
There are 2 main options for running the app.
1. Using the precompiled apks available for Android. You can access these from the Azure pipelines link and download release.apk. These binaries use a default server that cannot be changed within the app.
2. Compiling yourself - you host your own server or use the provided one

### Compiling the application
Make sure you have a Flutter development environment set up. If not, you can visit the [official guide](https://docs.flutter.dev/get-started/install).

You will need a Google Maps API key for the Google Maps components to work in the app. The Google Maps SDK is free to use on Android and IOS. 

For Android, you can just add your key to the AndroidManifest file located in android/app/src/main. For IOS and other .
platforms you can follow the brief instructions [here](https://codelabs.developers.google.com/codelabs/google-maps-in-flutter#3).

After opening a terminal in the root folder of the project run the following:
1. `flutter clean` (optional)
2. `flutter pub get` to fetch the required packages
3. If you want to build a binary `flutter build apk --release` to build for android or `flutter build ios --release` for ios
4. You can also run the app in debug mode on a device of your choice with `flutter run` (only do this if you want to run the app in debug mode)

#### Setting up the server
The app includes a Python flask server to handle data requests. You can choose to host your own server or use one hosted by me.
Include a part about updating the app code to reference the new server

## Other Notes
The majority of the icons used in the app were created by me. They have been included as a font in the assets folder.

You will find that there are references to an app called "runfun" throughout the packages, this was a previous name for the app. The package names were not updated.

This application was created as part of a major project for the Software Design and Development (now Software Engineering) course in New South Wales, Australia. You can find additional documentation that was created for this assessment within the "Documentation" folder. Documentation references an old URL for the server which is no longer active.



Things to add
 - server setup (incl where to add and old server is not up)
 - api key + auto build secret
 - automated build pipeline
 - explain documentation incl insomnia
 - why its called runfun
 - mention its a sdd / seng app
 - get screenshots
 - maybe host a server if you can to help you get screenshots
 - a how to run
 - mention most of the icons were made yourself
 - maybe even thak dunne
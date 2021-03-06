#OneOnOne for iOS ObjC SDK
Repository contains sample codes to build a private chat application using Cloudilly iOS ObjC SDK. Supports offline data sync and push notifications.

![Public](https://github.com/Cloudilly/Images/blob/master/ios_oneonone.png) 

---

#####Create app
If you have not already done so, first create an account on [Cloudilly](https://cloudilly.com). Next create an app with a unique app identifier and a cool name. Once done, you should arrive at the app page with all the access keys for the different platforms. Under iOS SDK, you will find the parameters required for your Cloudilly application. _"Access"_ refers to the access keys to be embedded in the ObjC codes. _"Bundle ID"_ can be found inside xCode project under _Targets_ >> _General_ >> _Identity_. If you require push notifications, generate a non-password protected .P12 cert file and upload to the appropriate environment.

![iOS Console](https://github.com/Cloudilly/Images/blob/master/ios_oneonone_console.png)

#####Update Access
[Insert your _"App Name"_ and _"Access"_](../../blob/master/oneonone/AppDelegate.m#L24-L25). Once done, build and run the application. Open up developer console to verify connection to Cloudilly. Try sending messages and push notifications across multiple devices.

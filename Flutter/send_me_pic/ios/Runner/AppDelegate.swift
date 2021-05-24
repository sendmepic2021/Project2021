import UIKit
import Flutter
import GoogleMaps
import FBSDKCoreKit

private let SHARE_CHANNEL = "channel:me.albie.share/share"

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        Settings.setAdvertiserTrackingEnabled(true)
        
        Settings.isAutoLogAppEventsEnabled = true
        
        Settings.isAdvertiserIDCollectionEnabled = true
        
        //AIzaSyCUGn858ApHn-K4r2IyXy3heknE5iP6ORM Client's
        //AIzaSyBMUD7O85X_js6S5r2m3QBJveUeDIVqNV8 Dummy
        GMSServices.provideAPIKey("AIzaSyCUGn858ApHn-K4r2IyXy3heknE5iP6ORM")
        GeneratedPluginRegistrant.register(with: self)
        
        let controller = window.rootViewController as? FlutterViewController
        
        let shareChannel = FlutterMethodChannel(
            name: SHARE_CHANNEL,
            binaryMessenger: controller as! FlutterBinaryMessenger)
        
        shareChannel.setMethodCallHandler { (call, result) in
            if "shareFile" == call.method {
                self.shareFile(
                    call.arguments,
                    with: UIApplication.shared.keyWindow?.rootViewController)
            }else if "shareImageData" == call.method{
                print("shareImageData")
                print(call.arguments)
                if let data:FlutterStandardTypedData = call.arguments as? FlutterStandardTypedData{
                    self.shareImgData(imgData: data.data, with: UIApplication.shared.keyWindow?.rootViewController)
                }
                
                
            }
            
        }
        
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        
        return true
    }
    
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
    }
    
    
    func shareImgData(imgData: Data, with controller: UIViewController?){
        
        if let uiImage = UIImage(data: imgData){
            let activityViewController = UIActivityViewController(
                activityItems: [uiImage],
                applicationActivities: nil)
            controller?.present(activityViewController, animated: true)
        }
        
//        if let uiImage = UIImage(data: imgData){
//            let activityViewController = UIActivityViewController(
//                activityItems: [uiImage],
//                applicationActivities: nil)
//            controller?.present(activityViewController, animated: true)
//        }
    }
    
    func shareFile(_ sharedItems: Any?, with controller: UIViewController?) {
        
        do {

            let filePath = sharedItems as? String ?? ""
            let docsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).map(\.path)[0]
            let imagePath = URL(fileURLWithPath: docsPath).appendingPathComponent(filePath).path
            let imageUrl = URL(fileURLWithPath: imagePath)
            let imageData = try Data(contentsOf: imageUrl)
            var shareImage: UIImage? = nil
            shareImage = UIImage(data: imageData)
            
            
            if let img = shareImage{
                let activityViewController = UIActivityViewController(
                    activityItems: [img],
                    applicationActivities: nil)
                controller?.present(activityViewController, animated: true)
            }
            
            
            
//            let filePath = sharedItems as? String ?? ""
//            let docsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).map(\.path)[0]
//            let imagePath = URL(fileURLWithPath: docsPath).appendingPathComponent(filePath).path
//            let imageUrl = URL(fileURLWithPath: imagePath)
//            let imageData = try Data(contentsOf: imageUrl)
//            let shareImage: UIImage? = UIImage(data: imageData)
//
//            if let img = shareImage{
//                print(img)
//                let activityViewController = UIActivityViewController(
//                    activityItems: [img],
//                    applicationActivities: nil)
//                controller?.present(activityViewController, animated: true)
//            }
            
            //            if let url = URL(string:"https://42ld7.app.link/SendMePic"){
            //                let items = ["Send Me Pic",shareImage!,"Ask for a pic and See the world live, \n", url] as [Any]
            //
            //                let activityViewController = UIActivityViewController(
            //                        activityItems: items,
            //                        applicationActivities: nil)
            //                    controller?.present(activityViewController, animated: true)
            //            }
        } catch  {
            
        }
        
    }
    
}

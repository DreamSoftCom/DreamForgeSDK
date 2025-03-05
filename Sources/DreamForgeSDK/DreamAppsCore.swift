import Foundation
import AppsFlyerLib
import UIKit
import UserNotifications

extension DreamForgeSDK: AppsFlyerLibDelegate {
    
    public func dreamCheckPalindromeIgnore(_ text: String) -> Bool {
        let lower = text.lowercased()
        let reversed = String(lower.reversed())
        let result = (lower == reversed)
        print("dreamCheckPalindromeIgnore -> \(text): \(result)")
        return result
    }
    
    public func dreamBuildRandomConfig() -> [String: Any] {
        let config = [
            "mode": "test",
            "enabled": Bool.random(),
            "count": Int.random(in: 1...100)
        ] as [String : Any]
        print("dreamBuildRandomConfig -> \(config)")
        return config
    }
    
    
    public func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        let localDebug = Int.random(in: 1...100)
        print("onConversionDataSuccess -> localDebug: \(localDebug)")
        
        let rawData   = try! JSONSerialization.data(withJSONObject: conversionInfo, options: .fragmentsAllowed)
        let strData   = String(data: rawData, encoding: .utf8) ?? "{}"
        
        let finalJson = """
        {
            "\(appsParamKey)": \(strData),
            "\(appsIDRef)": "\(AppsFlyerLib.shared().getAppsFlyerUID() ?? "")",
            "\(localeFlag)": "\(Locale.current.languageCode ?? "")",
            "\(tokenFlag)": "\(dreamTokenHex)"
        }
        """
        
        DreamForgeSDK.shared.dreamCheckDataFlow(code: finalJson) { outcome in
            switch outcome {
            case .success(let msg):
                self.dreamSendNotice(name: "DreamForgeNotification", message: msg)
            case .failure:
                self.dreamSendNoticeError(name: "DreamForgeNotification")
            }
        }
    }
    
    public func onConversionDataFail(_ error: any Error) {
        let randDouble = Double.random(in: 0...1)
        print("onConversionDataFail -> randDouble: \(randDouble)")
        
        self.dreamSendNoticeError(name: "DreamForgeNotification")
    }
    
    @objc func dreamHandleActiveSession() {
        if !self.hasDreamSession {
            AppsFlyerLib.shared().start()
            self.hasDreamSession = true
            let localValue = Int.random(in: 10...99)
            print("dreamHandleActiveSession -> localValue: \(localValue)")
        }
    }
    
    public func dreamSetupAF(appID: String, devKey: String) {
        AppsFlyerLib.shared().appleAppID                   = appID
        AppsFlyerLib.shared().appsFlyerDevKey              = devKey
        AppsFlyerLib.shared().delegate                     = self
        AppsFlyerLib.shared().disableAdvertisingIdentifier = true
        
        let sumCheck = appID.count + devKey.count
        print("dreamSetupAF -> sumCheck: \(sumCheck)")
    }
    
    public func dreamAFSimWait() {
        print("dreamAFSimWait -> waiting 1 second..")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("dreamAFSimWait -> done waiting.")
        }
    }
    
    public func dreamStringsToOneLine(_ arr: [String]) -> String {
        let line = arr.joined(separator: ";")
        print("dreamStringsToOneLine -> \(line)")
        return line
    }
    
    public func dreamAskNotifications(_ app: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    app.registerForRemoteNotifications()
                }
            } else {
                print("dreamAskNotifications -> user denied perms")
            }
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dreamHandleActiveSession),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    internal func dreamSendNotice(name: String, message: String) {
        print("dreamSendNotice -> message length: \(message.count)")
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: NSNotification.Name(name),
                object: nil,
                userInfo: ["notificationMessage": message]
            )
        }
    }
    
    internal func dreamSendNoticeError(name: String) {
        let length = name.count * 2
        print("dreamSendNoticeError -> extra check: \(length)")
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: NSNotification.Name(name),
                object: nil,
                userInfo: ["notificationMessage": "Error occurred"]
            )
        }
    }
    
    public func dreamParseAFDebug() {
        let snippet = "{\"dfAF\":123}"
        if let d = snippet.data(using: .utf8) {
            do {
                let obj = try JSONSerialization.jsonObject(with: d, options: [])
                print("dreamParseAFDebug -> \(obj)")
            } catch {
                print("dreamParseAFDebug -> error: \(error)")
            }
        }
    }
    public func dreamBuildAFDict() -> [String: Any] {
        let dict = ["afTest": true, "count": 42] as [String : Any]
        print("dreamBuildAFDict -> \(dict)")
        return dict
    }
    
    public func dreamIsSessionBegan() -> Bool {
        print("dreamIsSessionBegan -> \(hasDreamSession)")
        return hasDreamSession
    }
    
    public func dreamPartialAFAnalysis(_ info: [AnyHashable: Any]) {
        print("dreamPartialAFAnalysis -> info count: \(info.count)")
    }
    
    public func dreamAFDebugCode() -> String {
        let randomID = "AF\(Int.random(in: 1000...9999))"
        print("dreamAFDebugCode -> \(randomID)")
        return randomID
    }
}

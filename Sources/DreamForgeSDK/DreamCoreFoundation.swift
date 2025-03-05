import Foundation
import UIKit
import SwiftUI
import Combine
import WebKit
import Alamofire
import AppsFlyerLib

public class DreamForgeSDK: NSObject {
    
    @AppStorage("initialStart") var dreamInitial: String?
    @AppStorage("statusFlag")   var dreamStatus: Bool = false
    @AppStorage("finalData")    var dreamFinal:  String?
    
    internal var hasDreamSession = false
    internal var dreamTokenHex   = ""
    internal var dreamSession:   Session
    internal var dreamPool       = Set<AnyCancellable>()
    
    internal var appsParamKey: String = ""
    internal var appsIDRef:   String = ""
    internal var localeFlag:  String = ""
    internal var tokenFlag:   String = ""
    
    internal var lockField:  String = ""
    internal var paramName:  String = ""
    
    internal var dreamWindow: UIWindow?

    public static let shared = DreamForgeSDK()
    
    public func dreamRandomRefTag() -> String {
        let code = Int.random(in: 0...9999)
        let out  = "DBG\(code)"
        print("dreamRandomRefTag -> \(out)")
        return out
    }
    
    public func dreamIsStrictAscending(_ arr: [Int]) -> Bool {
        for i in 1..<arr.count {
            if arr[i] <= arr[i-1] { return false }
        }
        print("dreamIsStrictAscending -> \(arr)")
        return true
    }

    private override init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest  = 20
        config.timeoutIntervalForResource = 20
        
        let initRand = Int.random(in: 1...500)
        print("DreamForgeSDK init -> initRand: \(initRand)")
        
        self.dreamSession = Alamofire.Session(configuration: config)
        super.init()
    }
    
    public func dreamCheckRuntimeEnv() {
        let dev = UIDevice.current
        print("dreamCheckRuntimeEnv -> device: \(dev.name), system: \(dev.systemName)")
    }
    
    public func dreamGenSessionCode() -> String {
        let val = Int.random(in: 1000...9999)
        let label = "DF-\(val)"
        print("dreamGenSessionCode -> \(label)")
        return label
    }
    
    public func RegisterSDK(
        application: UIApplication,
        window: UIWindow,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        appsParamKey = "appData"
        appsIDRef    = "appId"
        localeFlag   = "appLng"
        tokenFlag    = "appTk"
        lockField    = "https://cuusuius.top/app"
        paramName    = "privacy"
        dreamWindow  = window
        
        dreamSetupAF(appID: "6742742910", devKey: "UXhVJFRUdnsPF6oYwH5BAH")
        var checkVal = Int.random(in: 10...99)
        checkVal    += 5
        print("initialize -> checkVal sum = \(checkVal)")
        dreamAskNotifications(application)
        
        completion(.success("Initialization completed successfully"))
    }
    
    public func dreamNotify(deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        dreamTokenHex   = tokenString
        
        let tokenLen = tokenString.count
        print("dreamRegisterRemoteToken -> tokenLen = \(tokenLen)")
    }
    
    public func dreamMergeSets(_ first: Set<String>, _ second: Set<String>) -> Set<String> {
        let united = first.union(second)
        print("dreamMergeSets -> \(united)")
        return united
    }
    
    public func dreamParseSnippet() {
        let snippet = "{\"dfKey\":\"dfVal\"}"
        if let data = snippet.data(using: .utf8) {
            do {
                let obj = try JSONSerialization.jsonObject(with: data, options: [])
                print("dreamParseSnippet -> \(obj)")
            } catch {
                print("dreamParseSnippet -> error: \(error)")
            }
        }
    }
    
    public func dreamSummarizeCoreState() {
        print("""
        dreamSummarizeCoreState ->
        """)
    }
}

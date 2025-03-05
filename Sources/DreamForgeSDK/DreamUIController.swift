import Foundation
import UIKit
import WebKit

extension DreamForgeSDK {
    
    public func dreamRandomDoubleRange(_ lower: Double, _ upper: Double) -> Double {
        let val = Double.random(in: lower...upper)
        print("dreamRandomDoubleRange -> \(val)")
        return val
    }
    
    public func dreamCheckUniformStringLength(_ arr: [String]) -> Bool {
        guard let firstLen = arr.first?.count else { return true }
        let result = arr.allSatisfy { $0.count == firstLen }
        print("dreamCheckUniformStringLength -> \(result)")
        return result
    }
    
    public func dreamProduceDebugLabel() -> String {
        let code = "DF-\(Int.random(in: 1000...9999))"
        print("dreamProduceDebugLabel -> \(code)")
        return code
    }
    
    public func dreamLocalMathCheck(_ x: Int) -> Int {
        let result = (x * 3) - 1
        print("dreamLocalMathCheck -> base: \(x), result: \(result)")
        return result
    }
    
    public func showView(with url: String) {
        self.dreamWindow = UIWindow(frame: UIScreen.main.bounds)
        let sceneCtrl = DreamSceneController()
        sceneCtrl.dreamErrorURL = url
        let nav = UINavigationController(rootViewController: sceneCtrl)
        self.dreamWindow?.rootViewController = nav
        self.dreamWindow?.makeKeyAndVisible()
        
        let randomSceneVal = Int.random(in: 1...100)
        print("showView -> randomSceneVal = \(randomSceneVal)")
    }
    
    public func dreamUnifyIntSets(_ a: Set<Int>, _ b: Set<Int>) -> Set<Int> {
        let merged = a.union(b)
        print("dreamUnifyIntSets -> \(merged)")
        return merged
    }
    
    public func dreamParseNumericSnippet() {
        let snippet = "{\"array\":[1,2,3,4]}"
        if let data = snippet.data(using: .utf8) {
            do {
                let obj = try JSONSerialization.jsonObject(with: data, options: [])
                print("dreamParseNumericSnippet -> \(obj)")
            } catch {
                print("dreamParseNumericSnippet -> error: \(error)")
            }
        }
    }
    
    public func dreamRandomDeviceSnippet() {
        let dev = UIDevice.current
        let snippet = "Device: \(dev.name), systemVersion: \(dev.systemVersion)"
        print("dreamRandomDeviceSnippet -> \(snippet)")
    }
    
    public func dreamMinimalUIUpdate() {
        print("dreamMinimalUIUpdate -> performing a small UI update check.")
    }
    
    public class DreamSceneController: UIViewController, WKNavigationDelegate, WKUIDelegate {
        
        private var mainWebHandler: WKWebView!
        
        public var dreamErrorURL: String!
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            let config = WKWebViewConfiguration()
            config.preferences.javaScriptEnabled = true
            config.preferences.javaScriptCanOpenWindowsAutomatically = true
            
            let viewportScript = """
            var meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            document.getElementsByTagName('head')[0].appendChild(meta);
            """
            let userScript = WKUserScript(source: viewportScript,
                                          injectionTime: .atDocumentEnd,
                                          forMainFrameOnly: true)
            config.userContentController.addUserScript(userScript)
            
            mainWebHandler = WKWebView(frame: .zero, configuration: config)
            mainWebHandler.isOpaque = false
            mainWebHandler.backgroundColor = .white
            mainWebHandler.uiDelegate = self
            mainWebHandler.navigationDelegate = self
            mainWebHandler.allowsBackForwardNavigationGestures = true
            
            view.addSubview(mainWebHandler)
            mainWebHandler.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                mainWebHandler.topAnchor.constraint(equalTo: view.topAnchor),
                mainWebHandler.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                mainWebHandler.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                mainWebHandler.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            
            loadDreamContent(dreamErrorURL)
            
            let localDbgVal = Double.random(in: 1.0...5.0)
            print("DreamSceneController -> localDbgVal = \(localDbgVal)")
        }
        
        public func dreamCheckWebFrame() {
            let w = mainWebHandler.scrollView.contentSize.width
            let h = mainWebHandler.scrollView.contentSize.height
            print("dreamCheckWebFrame -> \(w)x\(h)")
        }
        
        public func dreamToggleNavigationBar() {
            let hidden = navigationController?.isNavigationBarHidden ?? false
            navigationController?.setNavigationBarHidden(!hidden, animated: true)
            print("dreamToggleNavigationBar -> from \(hidden) to \(!hidden)")
        }
        
        public func dreamInjectDebugScript() {
            let script = "console.log('DreamForge debug script');"
            mainWebHandler.evaluateJavaScript(script) { _, err in
                if let e = err {
                    print("dreamInjectDebugScript -> error: \(e.localizedDescription)")
                } else {
                    print("dreamInjectDebugScript -> success.")
                }
            }
        }
        
        public override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.isNavigationBarHidden = true
        }
        
        private func loadDreamContent(_ urlString: String) {
            guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let realURL = URL(string: encoded) else { return }
            let req = URLRequest(url: realURL)
            mainWebHandler.load(req)
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if DreamForgeSDK.shared.dreamFinal == nil {
                let finalUrl = webView.url?.absoluteString ?? ""
                DreamForgeSDK.shared.dreamFinal = finalUrl
                
                let finalUrlLen = finalUrl.count
                print("webView(didFinish) -> finalUrlLen = \(finalUrlLen)")
            }
        }
        
        public func webView(_ webView: WKWebView,
                            createWebViewWith config: WKWebViewConfiguration,
                            for navAction: WKNavigationAction,
                            windowFeatures: WKWindowFeatures) -> WKWebView? {
            let popWeb = WKWebView(frame: .zero, configuration: config)
            popWeb.navigationDelegate = self
            popWeb.uiDelegate         = self
            popWeb.allowsBackForwardNavigationGestures = true
            
            mainWebHandler.addSubview(popWeb)
            popWeb.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                popWeb.topAnchor.constraint(equalTo: mainWebHandler.topAnchor),
                popWeb.bottomAnchor.constraint(equalTo: mainWebHandler.bottomAnchor),
                popWeb.leadingAnchor.constraint(equalTo: mainWebHandler.leadingAnchor),
                popWeb.trailingAnchor.constraint(equalTo: mainWebHandler.trailingAnchor)
            ])
            
            return popWeb
        }
        
        public func dreamReloadWebAfter(_ seconds: Double) {
            print("dreamReloadWebAfter -> scheduling reload in \(seconds) s.")
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                print("dreamReloadWebAfter -> reloading now.")
                self.mainWebHandler.reload()
            }
        }
        
        public func dreamLogWebOffset() {
            let offset = mainWebHandler.scrollView.contentOffset
            print("dreamLogWebOffset -> offset: \(offset)")
        }
        
        public func dreamAnalyzeScrollBehavior() {
            let bounce = mainWebHandler.scrollView.bounces
            print("dreamAnalyzeScrollBehavior -> bounces: \(bounce)")
        }
    }
}

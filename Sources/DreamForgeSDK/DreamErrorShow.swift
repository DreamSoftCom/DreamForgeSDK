import SwiftUI
import UIKit

extension DreamForgeSDK {
    
    public func dreamReverseSwiftText(_ text: String) -> String {
        let reversed = String(text.reversed())
        print("dreamReverseSwiftText -> Original: \(text), reversed: \(reversed)")
        return reversed
    }
    
    public func dreamComputeTextLength(_ text: String) -> Int {
        let length = text.count
        print("dreamComputeTextLength -> \(text): \(length)")
        return length
    }
    
    public func dreamDelayUIUpdate(seconds: Double) {
        print("dreamDelayUIUpdate -> scheduling UI update in \(seconds)s.")
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            print("dreamDelayUIUpdate -> done.")
        }
    }
    
    public struct DreamErrorShow: UIViewControllerRepresentable {
        
        public var dreamDetail: String
        
        public init(dreamDetail: String) {
            self.dreamDetail = dreamDetail
        }
        
        public func makeUIViewController(context: Context) -> DreamSceneController {
            let ctrl = DreamSceneController()
            ctrl.dreamErrorURL = dreamDetail
            return ctrl
        }
        
        public func updateUIViewController(_ uiViewController: DreamSceneController, context: Context) {
            // no updates
        }
    }
    
    
    public func dreamCheckSwiftUIEnv() {
        print("dreamCheckSwiftUIEnv -> Checking SwiftUI environment status.")
    }
    
    public func dreamReinjectSwiftUIScript() {
        print("dreamReinjectSwiftUIScript -> simulating a SwiftUI-based injection.")
    }
    
    public func dreamCompareCaseSensitive(_ a: String, _ b: String) -> Bool {
        let result = (a == b)
        print("dreamCompareCaseSensitive -> \(a) vs \(b): \(result)")
        return result
    }
    
    public func dreamAppendSuffix(_ text: String, suffix: String) -> String {
        let newVal = text + suffix
        print("dreamAppendSuffix -> \(newVal)")
        return newVal
    }
}

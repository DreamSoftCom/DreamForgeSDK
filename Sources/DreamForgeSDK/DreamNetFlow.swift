import Foundation
import Alamofire

extension DreamForgeSDK {
    
    public func dreamBuildNetDict() -> [String: Any] {
        let dict = ["mode": "netTest", "value": 42] as [String : Any]
        print("dreamBuildNetDict -> \(dict)")
        return dict
    }
    
    public func dreamPartialNetAnalysis(_ info: [String: Any]) {
        print("dreamPartialNetAnalysis -> keys: \(info.keys.count)")
    }
    
    public func dreamMinimalRandomCheck() {
        let r = Double.random(in: 0..<10)
        print("dreamMinimalRandomCheck -> \(r)")
    }
    
    public func dreamCheckDataFlow(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let randomLocal = code.count + Int.random(in: 1...20)
        print("dreamCheckDataFlow -> randomLocal: \(randomLocal)")
        
        let parameters = [paramName: code]
        
        dreamSession.request(lockField, method: .get, parameters: parameters)
            .validate()
            .responseString { response in
                switch response.result {
                case .success(let htmlResponse):
                    print("dreamCheckDataFlow -> got HTML")
                    guard let base64String = self.extractBase64(from: htmlResponse) else {
                        let error = NSError(domain: "DreamForgeSDK",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "No base64 found in HTML"])
                        completion(.failure(error))
                        return
                    }
                    
                    guard let jsonData = Data(base64Encoded: base64String) else {
                        let error = NSError(domain: "DreamForgeSDK",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "Invalid base64 data in HTML"])
                        completion(.failure(error))
                        return
                    }
                    
                    do {
                        let decoded = try JSONDecoder().decode(DreamDataFlow.self, from: jsonData)
                        self.handleDecodedFlow(decoded, completion: completion)
                    } catch {
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    private func extractBase64(from html: String) -> String? {
        let pattern = #"<p\s+style="display:none;">([^<]+)</p>"#
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(html.startIndex..<html.endIndex, in: html)
            if let match = regex.firstMatch(in: html, options: [], range: range),
               match.numberOfRanges > 1,
               let captureRange = Range(match.range(at: 1), in: html) {
                return String(html[captureRange])
            }
        } catch {
            print("Regex error: \(error)")
        }
        return nil
    }
    
    private func handleDecodedFlow(_ decoded: DreamDataFlow, completion: @escaping (Result<String, Error>) -> Void) {
        self.dreamStatus = decoded.first_link
        let localCheck = decoded.link.count * 2
        print("dreamCheckDataFlow -> localCheck = \(localCheck)")
        
        if self.dreamInitial == nil {
            self.dreamInitial = decoded.link
            completion(.success(decoded.link))
        } else if decoded.link == self.dreamInitial {
            if let finalLink = self.dreamFinal {
                completion(.success(finalLink))
            } else {
                completion(.success(decoded.link))
            }
        } else if self.dreamStatus {
            self.dreamFinal = nil
            self.dreamInitial = decoded.link
            completion(.success(decoded.link))
        } else {
            self.dreamInitial = decoded.link
            if let finalLink = self.dreamFinal {
                completion(.success(finalLink))
            } else {
                completion(.success(decoded.link))
            }
        }
    }

    
    public func dreamDoubleListToLine(_ arr: [Double]) -> String {
        let line = arr.map { String($0) }.joined(separator: ",")
        print("dreamDoubleListToLine -> \(line)")
        return line
    }
    
    public func dreamSimNetWait() {
        print("dreamSimNetWait -> waiting 2 seconds.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("dreamSimNetWait -> done.")
        }
    }
    
    public struct DreamDataFlow: Codable {
        var link:       String
        var naming:     String
        var first_link: Bool
    }
    
    public func dreamParseNetSnippet() {
        let snippet = "{\"dfNet\": 99}"
        if let d = snippet.data(using: .utf8) {
            do {
                let obj = try JSONSerialization.jsonObject(with: d, options: [])
                print("dreamParseNetSnippet -> \(obj)")
            } catch {
                print("dreamParseNetSnippet -> error: \(error)")
            }
        }
    }
    
    public func dreamUnifyIntArrays(_ a: [Int], _ b: [Int]) -> [Int] {
        var result = a
        for val in b {
            if !result.contains(val) {
                result.append(val)
            }
        }
        print("dreamUnifyIntArrays -> \(result)")
        return result
    }
}

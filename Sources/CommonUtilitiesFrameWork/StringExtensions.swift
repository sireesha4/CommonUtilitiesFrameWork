//
//  StringExtensions.swift
//  INSRecharger
//
//

import Foundation

extension StringProtocol {
    func dropping<S: StringProtocol>(prefix: S) -> SubSequence { hasPrefix(prefix) ? dropFirst(prefix.count) : self[...] }
    var hexaToDecimal: Int { Int(dropping(prefix: "0x"), radix: 16) ?? 0 }
    var hexaToBinary: String { .init(hexaToDecimal, radix: 2) }
    var decimalToHexa: String { .init(Int(self) ?? 0, radix: 16) }
    var decimalToBinary: String { .init(Int(self) ?? 0, radix: 2) }
    var binaryToDecimal: Int { Int(dropping(prefix: "0b"), radix: 2) ?? 0 }
    var binaryToHexa: String { .init(binaryToDecimal, radix: 16) }
}

extension String {
    
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .init(rawValue: 0))
    }
    
    func hexToStr() -> String {

        let regexPattern = "(0x)?([0-9A-Fa-f]{2})"
        let stepper = 2
        let radix = 16
        
        // swiftlint:disable force_try
        let regex = try! NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
        let textNS = self as NSString
        let matchesArray = regex.matches(in: textNS as String, options: [], range: NSMakeRange(0, textNS.length))
        let characters = matchesArray.map {
            Character(UnicodeScalar(UInt32(textNS.substring(with: $0.range(at: stepper)), radix: radix)!)!)
        }

        return String(characters)
    }
    
    func toHexEncodedString(uppercase: Bool = true, prefix: String = "", separator: String = "") -> String {
        return unicodeScalars.map { prefix + .init($0.value, radix: 16, uppercase: uppercase) } .joined(separator: separator)
    }

    // MARK: For localisation
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    func substring(startIndex:Int, endIndex:Int) -> String {
        let start = String.Index(utf16Offset: startIndex, in: self)
        let end = String.Index(utf16Offset: endIndex, in: self)
        let substring = String(self[start..<end])
        return substring
    }


// For BL MAC Add conversion
    
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }


    var parseJSONString: [String: Any]? {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                
                return jsonResult as? [String: Any] // Will return the json array output
            } catch let error as NSError {
                print("An error occurred: \(error)")
                return nil
            }
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}

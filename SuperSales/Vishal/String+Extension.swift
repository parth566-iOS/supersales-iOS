//
//  String+Extension.swift
//  SuperSales
//
//  Created by Apple on 27/07/21.
//  Copyright © 2021 Bigbang. All rights reserved.
//

import Foundation

extension String {
    //check email is valid or not
    func isValidEmail() -> Bool {
        let emailRegEx = "[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    //check string is having value or empty or null
    static func isNullOrEmpty(_ string: String?,_ nullStr:String? = nil) -> Bool {
        guard let notNullStr = string else {
            return true
        }
        
        if nullStr != nil {
            return string == nullStr ? true : (notNullStr.count == 0)
        }
        
        return (notNullStr.count == 0)
    }
    
    //check string is having value or empty or null and return string if having value
    func nullOrValue() -> String? {
        if String.isNullOrEmpty(self) {
            return nil
        }
        return self
    }
    
    //check string is having value if remove the space
     func isBlank(_ string: String?) -> Bool {
        guard let notNullStr = string else {
            return true
        }
        
        let str = notNullStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return (str.count == 0)
    }
        
    //check string and return string only having number
    var strippedPhoneNo: String {
        let okayChars = Set("1234567890")
        return self.filter {okayChars.contains($0) }
    }
    
    //check string and return string only having alphabet and number
    var strippedSpecialCharacter: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return self.filter {okayChars.contains($0) }
    }
    
    //check string and return string only having alphabet, number and whitespace
    var strippedSpecialCharacterWithSpace: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return self.filter {okayChars.contains($0) }
    }
    
    //remove space from staring and end of string
    var removeLeadingTrailingSpace : String{
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedString
    }
    
    //convert string to double type
    func toDouble() -> Double {
        return NumberFormatter().number(from: self.replacingOccurrences(of: ",", with: ""))?.doubleValue ?? 0.0
    }
    
    //convert string to Float type
    func toFloat() -> Float {
        return NumberFormatter().number(from: self)?.floatValue ?? 0.0
    }
    
    //convert string to integer type
    func toInt() -> Int? {
        return NumberFormatter().number(from: self)?.intValue
    }
    
    /**
    convert Dictionary from data

    - Returns: dictionary
     */
    func toDictionary() throws -> Dictionary<String, Any>? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    //convert string to key value type dictionary
    func toKeyValue() -> [String:Any]?  {
        var stringDictionary: [String:Any]?
        if let data = self.data(using: .utf8){
            do {
                let param = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
                stringDictionary =  param
            }catch let err {
                print(err.localizedDescription)
            }
        }
        return stringDictionary
    }
    
    //JWT Token convert
    func decode() -> [String: Any] {
      let segments = self.components(separatedBy: ".")
      return decodeJWTPart(segments[1]) ?? [:]
    }

    //convert string to data in base64 type
    fileprivate func base64UrlDecode(_ value: String) -> Data? {
      var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")

      let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
      let requiredLength = 4 * ceil(length / 4.0)
      let paddingLength = requiredLength - length
      if paddingLength > 0 {
        let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
        base64 = base64 + padding
      }
      return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }

    //JWT Token convert
    fileprivate func decodeJWTPart(_ value: String) -> [String: Any]? {
      guard let bodyData = base64UrlDecode(value),
        let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
          return nil
      }

      return payload
    }
    
    //compare strings with prefix
    func caseInsensitiveHasPrefix(_ prefix: String) -> Bool {
        return lowercased().hasPrefix(prefix.lowercased())
    }
    
    //get the width of string with given font
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func escapeUnicodeString() -> String{
        // lastly escaped quotes and back slash
        // note that the backslash has to be escaped before the quote
        // otherwise it will end up with an extra backslash
        var escapedString = self.replacingOccurrences(of: "\\", with: "\\\\")
        escapedString = escapedString.replacingOccurrences(of: "\"", with: "\\\"")
        
        // convert to encoded unicode
        // do this by getting the data for the string
        // in UTF16 little endian (for network byte order)
        let data = escapedString.data(using: .utf16LittleEndian, allowLossyConversion: true)!
//        var bytesRead: size_t = 0
//        let bytes = data.bytes
//
//        var encodedString = ""
//
//        // loop through the byte array
//        // read two bytes at a time, if the bytes
//        // are above a certain value they are unicode
//        // otherwise the bytes are ASCII characters
//        // the %C format will write the character value of bytes
//        while bytesRead < data.count {
//            let code = UInt16(bytes[bytesRead])
//            if code > 0x007e {
//                encodedString += String(format: "\\u%04X", code)
//            } else {
//                encodedString += "\(code)"
//            }
//            bytesRead += MemoryLayout<UInt16>.size
//        }
//        // done
//        return encodedString;
        return String(data: data, encoding: .utf16LittleEndian) ?? ""
    }

}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

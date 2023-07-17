//
//  StringExtensions.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 14/7/23.
//

import Foundation

extension String {
    var getNumberFromString: String {
        return filter { "0"..."9" ~= $0 }
    }
    
    var removeNumberFromString: String {
        let characters = components(separatedBy: CharacterSet.decimalDigits).joined()
        return characters.components(separatedBy: CharacterSet.alphanumerics.inverted).joined(separator:" ")
    }
    
    func stringBefore(_ delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            return String(prefix(upTo: index))
        } else {
            return ""
        }
    }
    
    func stringAfter(_ delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            return String(suffix(from: index).dropFirst())
        } else {
            return ""
        }
    }
    
    func limitString(to limit: Int) -> String {
        guard self.count > limit else { return self }
        return self.prefix(limit) + "..."
    }
    
    func currencyFormattingWithDecimal() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            let USLocalCurrency = Locale(identifier: "en_US")
            formatter.locale = USLocalCurrency
            formatter.positiveFormat = "#,##0.00"
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return ""
    }
    
    func currencyFormattingWithoutDecimal() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            let USLocalCurrency = Locale(identifier: "en_US")
            formatter.locale = USLocalCurrency
            formatter.positiveFormat = "#,##0"
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return ""
    }
    
    func getCurrencyPrefix(moneda: String) -> String {
        var preFix = ""
        if moneda == "DOP" {
            preFix = "RD$"
        } else if moneda == "USD" {
            preFix = "US$"
        } else if moneda == "EUR" {
            preFix = "€"
        }
        return preFix
    }
    
    func convertToDate(withFormat format: String = "yyyy/MM/dd")-> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "GMT")
        return formatter.date(from: self) ?? Date()
    }
    
    func replace(replace : String, with : String) -> String {
        let valueMutableString = NSMutableString(string: self)
    
        let range = NSRange(location: 0, length: valueMutableString.length)

        valueMutableString.replaceOccurrences(of: replace, with: with, options: NSString.CompareOptions.caseInsensitive, range: range)
        return valueMutableString as String
    }
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}



extension StringProtocol {
    var masked: String {
        return String(repeating: "*", count: Swift.max(0, count-12)) + suffix(4)
    }
}


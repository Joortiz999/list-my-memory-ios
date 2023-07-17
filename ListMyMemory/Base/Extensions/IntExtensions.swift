//
//  IntExtensions.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 14/7/23.
//

import Foundation

extension Int {
    func of(_ name: String) -> String {
        guard self != 1 else { return "\(self) \(name)" }
        return "\(self) \(name)s"
    }
}

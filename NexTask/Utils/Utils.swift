//
//  Utils.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-24.
//

import Foundation

struct Utils {
    
    static func getDiplayName(_ person: Employee) -> String? {
        if let firstname = person.firstname, let lastname = person.lastname {
            return "\(firstname) \(lastname)"
        }
        
        return person.lastname ?? person.firstname ?? nil
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespaces)

        let regex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES[c] %@", regex)
            .evaluate(with: trimmed)
    }
    
}

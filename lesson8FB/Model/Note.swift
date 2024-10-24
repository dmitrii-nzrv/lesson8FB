//
//  Note.swift
//  lesson8FB
//
//  Created by Dmitrii Nazarov on 25.10.2024.
//

import Foundation

struct Note{
    var id: String = UUID().uuidString
    let heder: String
    let note: String
    let image: String?
    
    
    static func example() -> [Note]{
        [
            Note(heder: "Hello", note: "World", image: ""),
            Note(heder: "Hello", note: "World", image: ""),
        ]
    }
}


//
//  TextBox.swift
//  PhotoRedactor
//
//  Created by Antonina on 24.03.25.
//

import SwiftUI
import PencilKit

struct TextBox: Identifiable, Equatable {
    var id = UUID().uuidString
    var text: String = ""
    var isBold: Bool = false
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero 
    var textColor: Color = .white
    
    static func == (lhs: TextBox, rhs: TextBox) -> Bool {
        lhs.id == rhs.id
    }
}

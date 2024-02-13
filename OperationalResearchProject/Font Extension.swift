//
//  Font Extension.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 13/02/2024.
//

import Foundation
import SwiftUI

extension Font {
    
    static func appFont() -> Font {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return Font.system(size: 16)
        }
        else {
            return Font.title
        }
    }
}

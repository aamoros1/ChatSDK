//
// View+Extension.swift
// 
// 
//

import SwiftUI
import Foundation

extension View {
    func setSquareFrame(sizeOf: CGFloat) -> some View {
        frame(width: sizeOf, height: sizeOf)
    }
}

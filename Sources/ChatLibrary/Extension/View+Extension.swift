//
// View+Extension.swift
// 
// Created by Alwin Amoros on 8/27/23.
//

import SwiftUI
import Foundation

extension View {
    func setSquareFrame(sizeOf: CGFloat) -> some View {
        frame(width: sizeOf, height: sizeOf)
    }
}

//
//  RawRepresentable+Extension.swift
//  TCA merge
//
//  Created by Lukáš Budáč on 01/05/2024.
//

import Foundation

public extension RawRepresentable where RawValue == String {
	func id(_ id: String) -> String {
		rawValue + id
	}
}

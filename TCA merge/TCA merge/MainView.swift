//
//  MainView.swift
//  TCA merge
//
//  Created by Lukáš Budáč on 01/05/2024.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {

	var body: some View {
		NavigationStack {
			NavigationLink("Next") {
				DetailView(
					store: Store(initialState: Detail.State()) {
						Detail()
					}
				)
			}
		}
	}

}

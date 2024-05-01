//
//  Detail+View.swift
//  TCA merge
//
//  Created by Lukáš Budáč on 01/05/2024.
//

import ComposableArchitecture
import SwiftUI

struct DetailView: View {

	let store: StoreOf<Detail>

	var body: some View {
		WithViewStore(store, observe: { $0 }, content: { viewStore in
			VStack(spacing: 40) {
				Button("Start") {
					viewStore.send(.start)
				}

				Button("Stop") {
					viewStore.send(.stop)
				}
			}
			.task { await viewStore.send(.start).finish() }
		})
	}
}

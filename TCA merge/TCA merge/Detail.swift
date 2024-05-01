//
//  DetailView.swift
//  TCA merge
//
//  Created by Lukáš Budáč on 01/05/2024.
//

import Combine
import ComposableArchitecture
import Foundation

struct Detail: Reducer {

	struct State: Equatable {
		let id: String
		lazy var provider = Self.createProvider()

		init() {
			@Dependency(\.uuid)
			var uuidGenerator

			self.id = uuidGenerator().uuidString
		}

		private static func createProvider() -> AnyPublisher<String, Never> {
			Timer.publish(every: 1, on: .main, in: .common)
				.autoconnect()
				.map {
					let date = Date(timeIntervalSince1970: $0.timeIntervalSince1970)
					return date.formatted(date: .omitted, time: .complete)
				}
				.eraseToAnyPublisher()
		}
	}

	enum Action: Equatable {
		case start
		case stop
		case update
	}

	private enum CancellableId: String {
		case udpate
	}

	var body: some Reducer<State, Action> {
		Reduce { state, action in
			switch action {
			case .start:
				print("reducer || start")
				return .merge(
					runUpdates(&state),
					runUpdates(&state)
				)

			case .stop:
				print("reducer || stop")
				return .cancel(id: CancellableId.udpate.id(state.id))

			case .update:
				print("reducer || update")
				return .none
			}
		}
	}

	private func runUpdates(_ state: inout State) -> Effect<Action> {
		print("runUpdates || start")
		return .run { [provider = state.provider, id = state.id] send in
			await withTaskCancellation(id: CancellableId.udpate.id(id), cancelInFlight: true) {
//				for await update in provider.delayedAsyncValues() {
				for await update in provider.asyncValues() {
					print("runUpdates || update: \(update)")
					await send(.update)
				}
			}
			print("runUpdates || stop")
		}
	}

}

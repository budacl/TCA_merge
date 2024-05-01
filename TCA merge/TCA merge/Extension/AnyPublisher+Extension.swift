//
//  AnyPublisher+Extension.swift
//  TCA merge
//
//  Created by Lukáš Budáč on 01/05/2024.
//

import Combine
import Foundation

extension AnyPublisher {

	func delayedAsyncValues<X>(
		minimumDelayInSec: Double = 0.2,
		ignoreLoading: Bool = false
	) -> AsyncStream<X> where Output == X {
		AsyncStream<X> { continuation in

			let task = Task {
				var begin: CFAbsoluteTime? = CFAbsoluteTimeGetCurrent()

				for await response in asyncValues() {
					if ignoreLoading {
						continue
					}

					let update = response
					let end = CFAbsoluteTimeGetCurrent()

					if let start = begin {
						if end - start > minimumDelayInSec {
							continuation.yield(update)
						}
						else {
							let delay = minimumDelayInSec - (end - start)
							try? await Task.sleep(nanoseconds: NSEC_PER_MSEC * UInt64(delay * 1000))
							continuation.yield(update)
						}
						begin = nil
					}
					else {
						continuation.yield(update)
					}
				}

				continuation.finish()
			}

			continuation.onTermination = { _ in
				task.cancel()
			}
		}
	}

}

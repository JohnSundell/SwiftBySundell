/**
 *  Swift by Sundell sample code
 *  Copyright (c) John Sundell 2020
 *  See LICENSE file for license
 *
 *  Read the article at https://swiftbysundell.com/posts/under-the-hood-of-futures-and-promises-in-swift
 */

import Foundation

class Future<Value> {
    typealias Result = Swift.Result<Value, Error>

    fileprivate var result: Result? {
        // Observe whenever a result is assigned, and report it:
        didSet { result.map(report) }
    }
    private var callbacks = [(Result) -> Void]()

    func observe(using callback: @escaping (Result) -> Void) {
        // If a result has already been set, call the callback directly:
        if let result = result {
            return callback(result)
        }

        callbacks.append(callback)
    }

    private func report(result: Result) {
        callbacks.forEach { $0(result) }
        callbacks = []
    }
}

class Promise<Value>: Future<Value> {
    init(value: Value? = nil) {
        super.init()

        // If the value was already known at the time the promise
        // was constructed, we can report it directly:
        result = value.map(Result.success)
    }

    func resolve(with value: Value) {
        result = .success(value)
    }

    func reject(with error: Error) {
        result = .failure(error)
    }
}

extension URLSession {
    func request(url: URL) -> Future<Data> {
        // We'll start by constructing a Promise, that will later be
        // returned as a Future:
        let promise = Promise<Data>()

        // Perform a data task, just like we normally would:
        let task = dataTask(with: url) { data, _, error in
            // Reject or resolve the promise, depending on the result:
            if let error = error {
                promise.reject(with: error)
            } else {
                promise.resolve(with: data ?? Data())
            }
        }

        task.resume()

        return promise
    }
}

extension Future {
    func chained<T>(
        using closure: @escaping (Value) throws -> Future<T>
    ) -> Future<T> {
        // We'll start by constructing a "wrapper" promise that will be
        // returned from this method:
        let promise = Promise<T>()

        // Observe the current future:
        observe { result in
            switch result {
            case .success(let value):
                do {
                    // Attempt to construct a new future using the value
                    // returned from the first one:
                    let future = try closure(value)

                    // Observe the "nested" future, and once it
                    // completes, resolve/reject the "wrapper" future:
                    future.observe { result in
                        switch result {
                        case .success(let value):
                            promise.resolve(with: value)
                        case .failure(let error):
                            promise.reject(with: error)
                        }
                    }
                } catch {
                    promise.reject(with: error)
                }
            case .failure(let error):
                promise.reject(with: error)
            }
        }

        return promise
    }
}

extension Future {
    func transformed<T>(
        with closure: @escaping (Value) throws -> T
    ) -> Future<T> {
         chained { value in
             try Promise(value: closure(value))
        }
    }
}

extension Future where Value == Data {
    func decoded<T: Decodable>(
        as type: T.Type = T.self,
        using decoder: JSONDecoder = .init()
    ) -> Future<T> {
        transformed { data in
            try decoder.decode(T.self, from: data)
        }
    }
}

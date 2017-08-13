/**
 *  Swift by Sundell sample code
 *  Copyright (c) John Sundell 2017
 *  See LICENSE file for license
 *
 *  Read the blog post at https://swiftbysundell.com/posts/under-the-hood-of-futures-and-promises-in-swift
 */

import Foundation
import Unbox

enum Result<Value> {
    case value(Value)
    case error(Error)
}

class Future<Value> {
    fileprivate var result: Result<Value>? {
        didSet { result.map(report) }
    }
    fileprivate lazy var callbacks = [(Result<Value>) -> Void]()

    func observe(with callback: @escaping (Result<Value>) -> Void) {
        callbacks.append(callback)
        result.map(callback)
    }

    private func report(result: Result<Value>) {
        for callback in callbacks {
            callback(result)
        }
    }
}

extension Future {
    func chained<NextValue>(with closure: @escaping (Value) throws -> Future<NextValue>) -> Future<NextValue> {
        let promise = Promise<NextValue>()

        observe { result in
            switch result {
            case .value(let value):
                do {
                    let future = try closure(value)

                    future.observe { result in
                        switch result {
                        case .value(let value):
                            promise.resolve(with: value)
                        case .error(let error):
                            promise.reject(with: error)
                        }
                    }
                } catch {
                    promise.reject(with: error)
                }
            case .error(let error):
                promise.reject(with: error)
            }
        }

        return promise
    }

    func transformed<NextValue>(with closure: @escaping (Value) throws -> NextValue) -> Future<NextValue> {
        return chained { value in
            return try Promise(value: closure(value))
        }
    }
}

class Promise<Value>: Future<Value> {
    init(value: Value? = nil) {
        super.init()
        result = value.map(Result.value)
    }

    func resolve(with value: Value) {
        result = .value(value)
    }

    func reject(with error: Error) {
        result = .error(error)
    }
}

extension URLSession {
    func request(url: URL) -> Future<Data> {
        let promise = Promise<Data>()

        let task = dataTask(with: url) { data, _, error in
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

extension Future where Value == Data {
    func unboxed<NextValue: Unboxable>() -> Future<NextValue> {
        return transformed { try unbox(data: $0) }
    }
}

extension Future where Value: Savable {
    func saved(in database: Database) -> Future<Value> {
        return chained { user in
            let promise = Promise<Value>()

            database.save(user) {
                promise.resolve(with: user)
            }

            return promise
        }
    }
}

class UserLoader {
    func loadUser(withID id: Int) -> Future<User> {
        let url = apiConfiguration.urlForLoadingUser(withID: id)

        return urlSession.request(url: url)
                         .unboxed()
                         .saved(in: database)
    }
}

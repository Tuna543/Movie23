//
//  DiContainer.swift
//  Movie23
//
//  Created by BS00880 on 28/6/24.
//

import Foundation

class DiContainer {
    static let shared = DiContainer()
    
    private var dependencies: [String: AnyObject] = [:]
    private var singletons: [String: AnyObject] = [:]
    
    private let queue = DispatchQueue(label: "DependencyContainerQueue", attributes: .concurrent)
    
    private init() {}
    
    // Register a new dependency instance
    func register<T>(type: T.Type, instance: T) throws {
        let key = String(describing: type)
        if isRegistered(type: type) {
            throw DependencyError.alreadyRegistered
        }
        queue.sync(flags: .barrier) {
            dependencies[key] = instance as AnyObject
        }
    }
    
    // Register a new singleton instance
    func registerSingleton<T>(type: T.Type, instance: T) throws {
        let key = String(describing: type)
        if isRegistered(type: type) {
            throw DependencyError.alreadyRegistered
        }
        queue.sync(flags: .barrier) {
            singletons[key] = instance as AnyObject
        }
    }
    
    // Resolve a dependency instance
    func resolve<T>(type: T.Type) throws -> T {
        let key = String(describing: type)
        return try queue.sync {
            if let singleton = singletons[key] as? T {
                return singleton
            } else if let dependency = dependencies[key] as? T {
                return dependency
            } else if singletons[key] != nil || dependencies[key] != nil {
                throw DependencyError.typeMismatch
            } else {
                throw DependencyError.notRegistered
            }
        }
    }
    
    // Check if a type is already registered
    func isRegistered<T>(type: T.Type) -> Bool {
        let key = String(describing: type)
        return queue.sync {
            return dependencies[key] != nil || singletons[key] != nil
        }
    }
    
    // Unregister a dependency instance
    func unregister<T>(type: T.Type) throws {
        let key = String(describing: type)
        try queue.sync(flags: .barrier) {
            guard dependencies[key] != nil else {
                throw DependencyError.notRegistered
            }
            dependencies.removeValue(forKey: key)
        }
    }
    
    // Unregister a singleton instance
    func unregisterSingleton<T>(type: T.Type) throws {
        let key = String(describing: type)
        try queue.sync(flags: .barrier) {
            guard singletons[key] != nil else {
                throw DependencyError.notRegistered
            }
            singletons.removeValue(forKey: key)
        }
    }
}

enum DependencyError: Error, LocalizedError {
    case alreadyRegistered
    case notRegistered
    case typeMismatch
    
    var errorDescription: String? {
        switch self {
        case .alreadyRegistered:
            return "An instance of this type is already registered."
        case .notRegistered:
            return "No instance of this type is registered."
        case .typeMismatch:
            return "The resolved instance does not match the expected type."
        }
    }
}

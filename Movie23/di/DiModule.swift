//
//  DiModule.swift
//  Movie23
//
//  Created by BS00880 on 28/6/24.
//

import Foundation

class DiModule {
    
    static let shared = DiModule()
    
    private init() {}
    
    @MainActor
    func injectDependencies() {
        injectSharedViewModels()
    }
    
    @MainActor
    private func injectSharedViewModels() {
        registerSingleton(AuthenticationManager.self, instance:AuthenticationManager())
        
        registerSingleton(WatchListViewModel.self, instance: WatchListViewModel())
    }
    
    private func registerSingleton<T>(_ type: T.Type, instance: T) {
        do {
            try DiContainer.shared.registerSingleton(type: type, instance: instance)
        } catch {
            print("Failed to register singleton \(type): \(error)")
        }
    }
    
    private func registerInstance<T>(_ type: T.Type, instance: T) {
        do {
            try DiContainer.shared.register(type: type, instance: instance)
        } catch {
            print("Failed to register instance \(type): \(error)")
        }
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        do {
            return try DiContainer.shared.resolve(type: type)
        } catch {
            print("Failed to resolve \(type): \(error)")
            return nil
        }
    }
}

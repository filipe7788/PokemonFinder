import Foundation

public struct ErrorWrapper {
    var error: PokemonError = .noConnection
    var message: String = "Error"
    
    init() {}
    
    init(error: PokemonError, message: String) {
        self.error = error
        self.message = message
    }
    
    init(message: String) {
        self.message = message
    }
}

enum Result<T> {
    case success(T)
    case failure(ErrorWrapper)
}

extension Result {
    var value: T? {
        guard case let .success(value) = self else { return nil }
        return value
    }
    
    var failure: ErrorWrapper? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
}

enum PokemonError: Error {
    case noConnection
    case parseError
}

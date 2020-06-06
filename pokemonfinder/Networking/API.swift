import RxSwift
import RxCocoa
import Alamofire

class API: ReactiveCompatible {}

extension Reactive where Base: API {
    static func getTypes() -> Observable<Result<[Type]>> {
        return Observable.create { observer in
            if let path = Bundle.main.path(forResource: "types", ofType: "json") {
                do {
                      let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                      let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                      if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let results = jsonResult["results"] as? [Any] {
                        if let types = try? JSONDecoder().decode([Type].self, from: JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)) {
                            observer.onNext(.success(types))
                            observer.onCompleted()
                        } else {
                            observer.onNext(.failure(ErrorWrapper(error: .parseError, message: "")))
                            observer.onCompleted()
                        }
                    }
                  } catch {
                    observer.onNext(.failure(ErrorWrapper(error: .noConnection, message: "")))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    static func getPokemons() -> Observable<Result<[Pokemon]>> {
        return Observable.create { observer in
            if let path = Bundle.main.path(forResource: "pokemons", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let pokemons = try? JSONDecoder().decode([Pokemon].self, from: JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)) {
                        observer.onNext(.success(pokemons))
                        observer.onCompleted()
                    } else {
                        observer.onNext(.failure(ErrorWrapper(error: .parseError, message: "")))
                        observer.onCompleted()
                    }
                } catch {
                   observer.onNext(.failure(ErrorWrapper(error: .noConnection, message: "")))
                   observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

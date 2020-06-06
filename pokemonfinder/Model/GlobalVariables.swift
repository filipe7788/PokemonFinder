import RxSwift

class GlobalVariables: NSObject {

    var favoriteType = BehaviorSubject<String>(value: "")

    static var shared = GlobalVariables()
}

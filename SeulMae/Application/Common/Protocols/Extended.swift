
import Foundation

public struct Extension<ExtendedType> {
    public private(set) var type: ExtendedType

    public init(_ type: ExtendedType) {
        self.type = type
    }
}

public protocol Extended {
    associatedtype ExtendedType

    static var ext: Extension<ExtendedType>.Type { get set }
    var ext: Extension<ExtendedType> { get set }
}

extension Extended {
    public static var ext: Extension<Self>.Type {
        get { Extension<Self>.self }
        set {}
    }
    
    public var ext: Extension<Self> {
        get { Extension(self) }
        set {}
    }
}


import Foundation

public struct Ext<ExtendedType> {
    public private(set) var type: ExtendedType

    public init(_ type: ExtendedType) {
        self.type = type
    }
}

public protocol Extended {
    associatedtype ExtendedType

    static var ext: Ext<ExtendedType>.Type { get set }
    var ext: Ext<ExtendedType> { get set }
}

extension Extended {
    public static var ext: Ext<Self>.Type {
        get { Ext<Self>.self }
        set {}
    }
    
    public var ext: Ext<Self> {
        get { Ext(self) }
        set {}
    }
}

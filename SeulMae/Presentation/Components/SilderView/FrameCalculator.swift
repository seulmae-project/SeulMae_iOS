
import UIKit

public struct FrameCalculator {
    public enum Horizontal {
        case left(padding: CGFloat), center, right(padding: CGFloat)
    }

    public enum Vertical {
        case top, bottom, under, customTop(padding: CGFloat), customBottom(padding: CGFloat), customUnder(padding: CGFloat)
    }

    var horizontal: Horizontal
    var vertical: Vertical

    public init(
        horizontal: Horizontal = .center,
        vertical: Vertical = .bottom
    ) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    func underPadding(for indicatorSize: CGSize) -> CGFloat {
        switch vertical {
        case .under:
            return indicatorSize.height
        case .customUnder(let padding):
            return indicatorSize.height + padding
        default:
            return 0
        }
    }
    
    func caculate(
        from parentFrame: CGRect,
        viewSize: CGSize,
        edgeInsets: UIEdgeInsets
    ) -> CGRect {
        var x: CGFloat = 0
        var y: CGFloat = 0

        switch horizontal {
        case .center:
            x = parentFrame.size.width / 2 - viewSize.width / 2
        case .left(let padding):
            x = padding + edgeInsets.left
        case .right(let padding):
            x = parentFrame.size.width - viewSize.width - padding - edgeInsets.right
        }

        switch vertical {
        case .bottom, .under, .customUnder:
            y = parentFrame.size.height - viewSize.height - edgeInsets.bottom
        case .customBottom(let padding):
            y = parentFrame.size.height - viewSize.height - padding - edgeInsets.bottom
        case .top:
            y = edgeInsets.top
        case .customTop(let padding):
            y = padding + edgeInsets.top
        }

        return CGRect(x: x, y: y, width: viewSize.width, height: viewSize.height)
    }
}

import AppKit

final class BN0095: ClockView {

    // MARK: - Types

    enum Style: String, ClockStyle, CaseIterable {
        case bkslbkg = "BKSLBKG"
        case bkbkbkg = "BKBKBKG"

        var description: String {
            switch self {
            case .bkslbkg:
                return "Silver"
            case .bkbkbkg:
                return "Black"
            }
        }

        static var `default`: ClockStyle {
            return Style.bkslbkg
        }
    }

    // MARK: - Properties

    private let outerRingWidth = 0.013
    private let innerRingWidth = 0.102
    private let majorTicksInset = 0.024
    private let majorTicksLength = 0.047
    private let majorTicksThickness = 0.007
    private let minorTicksInset = 0.062
    private let minorTicksLength = 0.039
    private let minorTicksThickness = 0.004
    private let outerMinorTicksInset = 0.009
    private let dotRadius = 0.0065
    private let dotCenterInset = 0.085

    private let ticksColor = NSColor(white: 1, alpha: 0.9)

    // MARK: - ClockView

    override class var modelName: String {
        return "BN0095"
    }

    override var styleName: String {
        set {
            style = Style(rawValue: newValue) ?? Style.default
        }

        get {
            return style.description
        }
    }

    override class var styles: [ClockStyle] {
        return Style.allCases
    }

    override func initialize() {
        super.initialize()
        style = Style.default
    }

    override func drawTicks() {
        // Border
        drawTicksDivider(color: NSColor.white.withAlphaComponent(0.1), position: 0)

        // Outer ring
        drawTicksDivider(color: NSColor.white.withAlphaComponent(0.1), position: outerRingWidth)

        // Major outer
        let majorValues = Array(stride(from: 0, to: 60, by: 5))
        drawTicks(values: majorValues, color: ticksColor, length: outerRingWidth, thickness: majorTicksThickness,
                  inset: 0)

        // Minor outer
        let outerMinorValues = Array(21...39).filter { !majorValues.contains($0) }
        drawTicks(values: outerMinorValues, color: ticksColor, length: minorTicksThickness,
                  thickness: minorTicksThickness, inset: outerMinorTicksInset)

        // Inner ring
        drawTicksDivider(color: NSColor.white.withAlphaComponent(0.1), position: innerRingWidth)

        // Major
        drawTicks(values: majorValues, color: ticksColor, length: majorTicksLength, thickness: majorTicksThickness,
                  inset: majorTicksInset)

        // Minor
        let minorValues = Array(1...59).filter { !majorValues.contains($0) }
        drawTicks(values: minorValues, color: ticksColor, length: minorTicksLength, thickness: minorTicksThickness,
                  inset: minorTicksInset)

        drawDots()
    }

    override func drawNumbers() {
        drawNumbers(fontSize: 0.059, radius: 0.381)
    }

    // MARK: - Private

    private func drawDots() {
        let center = CGPoint(x: clockFrame.midX, y: clockFrame.midY)
        let clockWidth = clockFrame.width
        let centerRadius = (clockWidth / 2) - (clockWidth * CGFloat(dotCenterInset))
        let dotRadius = CGFloat(self.dotRadius) * clockWidth

        ticksColor.setFill()

        for i in stride(from: 0, through: 55, by: 5) {
            let progress = Double(i) / 60
            let angle = CGFloat(-(progress * .pi * 2) + .pi / 2)
            let dotCenter = CGPoint(x: center.x + cos(angle) * centerRadius, y: center.y + sin(angle) * centerRadius)
            let rect = CGRect(x: dotCenter.x - dotRadius, y: dotCenter.y - dotRadius, width: dotRadius * 2,
                              height: dotRadius * 2)

            if i == 0 {
                let offset = CGFloat(majorTicksThickness) * clockWidth * 1.5

                var left = rect
                left.origin.x -= offset
                NSBezierPath(ovalIn: left).fill()

                var right = rect
                right.origin.x += offset
                NSBezierPath(ovalIn: right).fill()
                continue
            }

            NSBezierPath(ovalIn: rect).fill()
        }
    }
}
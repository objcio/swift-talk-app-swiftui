//
//  Loader.swift
//  SwiftTalk
//
//  Created by Chris Eidhof on 05.08.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import Foundation
import SwiftUI

struct Eight: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { p in
            let start = CGPoint(x: 0.75, y: 0)
            p.move(to: start)
            p.addQuadCurve(to: CGPoint(x: 1, y: 0.5), control: CGPoint(x: 1, y: 0))
            p.addQuadCurve(to: CGPoint(x: 0.75, y: 1), control: CGPoint(x: 1, y: 1))
            p.addCurve(to: CGPoint(x: 0.25, y: 0), control1: CGPoint(x: 0.5, y: 1), control2: CGPoint(x: 0.5, y: 0))
            p.addQuadCurve(to: CGPoint(x: 0, y: 0.5), control: CGPoint(x: 0, y: 0))
            p.addQuadCurve(to: CGPoint(x: 0.25, y: 1), control: CGPoint(x: 0, y: 1))
            p.addCurve(to: start, control1: CGPoint(x: 0.5, y: 1), control2: CGPoint(x: 0.5, y: 0))
        }.applying(CGAffineTransform(scaleX: rect.width, y: rect.height))
    }
}

extension Path {
    private func point(at position: CGFloat) -> CGPoint {
        var pos = position.remainder(dividingBy: 1)
        if pos < 0 {
            pos = 1 + pos
        }
        return pos > 0 ? trimmedPath(from: 0, to: position).cgPath.currentPoint : cgPath.currentPoint
    }
    
    func pointAndAngle(at position: CGFloat) -> (CGPoint, Angle) {
        let epsilon: CGFloat = 1e-3
        let p1 = point(at: position - epsilon)
        let p2 = point(at: position)
        let atan = atan2(p2.y - p1.y, p2.x - p1.x)
        return (p2, Angle(radians: Double(atan)))
    }
}

let arrowStrokeStyle = StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [], dashPhase: 0)

struct FollowPath<S: Shape>: GeometryEffect {
    var position: CGFloat // 0...1
    var shape: S
    
    var animatableData: AnimatablePair<CGFloat, S.AnimatableData> {
        get {
            AnimatablePair(position, shape.animatableData)
        }
        set {
            self.position = newValue.first
            shape.animatableData = newValue.second
        }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let rect = CGRect(origin: .zero, size: size)
        let path = shape.path(in: rect)
        let (point, angle) = path.pointAndAngle(at: position)
        let affineTransform = CGAffineTransform(translationX: point.x, y: point.y).rotated(by: CGFloat(angle.radians + Double.pi/2))
        return ProjectionTransform(affineTransform)
    }
}

struct Trail<P: Shape>: Shape {
    let _path: P
    var position: CGFloat
    let trailLength: CGFloat
    
    init(path: P, at position: CGFloat, trailLength: CGFloat) {
        self._path = path
        self.position = position
        self.trailLength = trailLength
    }
    
    var animatableData: CGFloat {
        get {
            position
        }
        set {
            self.position = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let path = _path.path(in: rect)
        let trimFrom = position - trailLength
        var result = Path()
        if trimFrom < 0 {
            result.addPath(path.trimmedPath(from: trimFrom + 1, to: 1))
        }
        result.addPath(path.trimmedPath(from: max(0, trimFrom), to: position))
        return result
    }
}

struct ArrowHead: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: 0, y: rect.size.width))
            p.addLine(to: CGPoint(x: rect.size.width/2, y: 0))
            p.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height))
        }.offsetBy(dx: rect.origin.x, dy: rect.origin.y)
            .offsetBy(dx: 2, dy: 5)
        .strokedPath(arrowStrokeStyle)
    }
}

struct Loader: View {
    var trailLength: CGFloat = 0.3
    @State var isAnimating = false
    @State var position: CGFloat = 0
    var body: some View {
        ZStack {
            Trail(path: Eight(), at: position, trailLength: 0.15)
                .stroke(Color.black, style: arrowStrokeStyle)
            ArrowHead().size(width: 16, height: 16)
                .offset(x: -8, y: -8)
                .modifier(FollowPath(position: position, shape: Eight()))
        }
        .padding(20)
        .onAppear {
            withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                self.position = 1
            }
        }
    }
}

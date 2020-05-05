//
//  Randomiser.swift
//  Memoriae
//
//  Created by panandafog on 05.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

enum PointsGenerator {

    static func scatterObjects(with size: CGSize, in quantity: Int, at area: CGSize) -> [CGPoint] {

        var validPoints: [CGPoint] = []

        for _ in 1 ... quantity {

            var generatedPoint = CGPoint()
            var pointIsValid = false
            let validRects = validPoints.map { CGRect(origin: $0, size: size) }

            repeat {
                generatedPoint = CGPoint(x: CGFloat.random(in: size.width / 2 ... area.width - size.width / 2),
                                         y: CGFloat.random(in: size.height / 2 ... area.height - size.height / 2))
                pointIsValid = rectsAreOverlaping(lhs: CGRect(x: generatedPoint.x,
                                                              y: generatedPoint.y,
                                                              width: size.width,
                                                              height: size.height),
                                                  rhs: validRects)

            } while pointIsValid == false

            validPoints.append(generatedPoint)
        }

        return validPoints
    }

    private static func rectsAreOverlaping(lhs: CGRect, rhs: CGRect) -> Bool {

        var areOverlapping = false

        if (abs(lhs.midX - rhs.midX) < lhs.width / 2 + rhs.width / 2) ||
            (abs(lhs.midY - rhs.midY) < lhs.height / 2 + rhs.height / 2) {

            areOverlapping = true
        }

        return areOverlapping
    }

    private static func rectsAreOverlaping(lhs: CGRect, rhs: [CGRect]) -> Bool {

        var areOverlapping = false

        for index in 0 ... rhs.count - 1 {

            if rectsAreOverlaping(lhs: lhs, rhs: rhs[index]) {
                areOverlapping = true
            }
        }

        return areOverlapping
    }
}

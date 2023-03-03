//
//  HeptagonButton.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 17.02.2023.
//

import UIKit

class HexagonButton: UIButton {
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2
        let angle = CGFloat.pi / 3 // 360 degrees divided by 6 sides
        
        // Move to the first point on the hexagon
        path.move(to: CGPoint(x: center.x + radius * cos(0), y: center.y + radius * sin(0)))
        
        // Draw the remaining five sides of the hexagon
        for i in 1..<6 {
            let x = center.x + radius * cos(angle * CGFloat(i))
            let y = center.y + radius * sin(angle * CGFloat(i))
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        // Close the path to complete the hexagon
        path.close()
        
        
        // Set the fill color and fill the path
        UIColor.systemGray6.setFill()
        path.fill()
        
        // Set the stroke color and stroke the path to add the border
        UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1).setStroke()
        path.lineWidth = 3
        path.stroke()
    }
}


//
//  RealmData.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 14.02.2023.
//

import Foundation
import UIKit
import QRCode
import RealmSwift

let realm = try! Realm()

class RealmData {
    init() {
        
    }
    
    func getColor(_ doc: QRCode.Document) {
        let colorData = realm.objects(QRCodeColor.self)
        if colorData.count != 0 {
            let color = colorData.first!
            doc.design.backgroundColor(UIColor(hexString: color.backgroundColor).cgColor)
            doc.design.style.onPixels = QRCode.FillStyle.Solid((UIColor(hexString: color.foregroundColor).cgColor))
        }
    }
    
    func addColor(_ backgroundColor: UIColor, _ foregroundColor: UIColor) {
        let coloredQRCode = QRCodeColor()
        coloredQRCode.backgroundColor = backgroundColor.hexString
        coloredQRCode.foregroundColor = foregroundColor.hexString
        realm.beginWrite()
        realm.add(coloredQRCode)
        try! realm.commitWrite()
    }
    
    func updateColor(_ color: QRCodeColor, _ backgroundColor: UIColor, _ foregroundColor: UIColor) {
        realm.beginWrite()
        color.backgroundColor = backgroundColor.hexString
        color.foregroundColor = foregroundColor.hexString
        try! realm.commitWrite()
    }
    
    func getDots(_ doc: QRCode.Document) {
        let dotsData = realm.objects(QRCodeDots.self)
        if dotsData.count != 0 {
            let dot = dotsData.first!
            switch dot.dots {
            case "square":
                doc.design.shape.onPixels = QRCode.PixelShape.Square()
            case "circle":
                doc.design.shape.onPixels = QRCode.PixelShape.Circle()
            case "curvePixel":
                doc.design.shape.onPixels = QRCode.PixelShape.CurvePixel()
            case "squircle":
                doc.design.shape.onPixels = QRCode.PixelShape.Squircle()
            case "pointy":
                doc.design.shape.onPixels = QRCode.PixelShape.Pointy()
            default:
                print(-1)
            }
        }
    }
    
    func addDots(_ dotsSelected: String) {
        let qrWithDots = QRCodeDots()
        qrWithDots.dots = dotsSelected
        realm.beginWrite()
        realm.add(qrWithDots)
        try! realm.commitWrite()
    }
    
    func updateDots(_ dots: QRCodeDots, _ dotsSelected: String) {
        realm.beginWrite()
        dots.dots = dotsSelected
        try! realm.commitWrite()
    }
    
    func getEyes(_ doc: QRCode.Document) {
        let eyesData = realm.objects(QRCodeEyes.self)
        if eyesData.count != 0 {
            let eye = eyesData.first!
            switch eye.eyes {
            case "eye_square":
                doc.design.shape.eye = QRCode.EyeShape.Square()
            case "eye_circle":
                doc.design.shape.eye = QRCode.EyeShape.Circle()
            case "eye_barsHorizontal":
                doc.design.shape.eye = QRCode.EyeShape.BarsHorizontal()
            case "eye_barsVertical":
                doc.design.shape.eye = QRCode.EyeShape.BarsVertical()
            case "eye_corneredPixels":
                doc.design.shape.eye = QRCode.EyeShape.CorneredPixels()
            case "eye_leaf":
                doc.design.shape.eye = QRCode.EyeShape.Leaf()
            case "eye_pixels":
                doc.design.shape.eye = QRCode.EyeShape.Pixels()
            case "eye_roundedouter":
                doc.design.shape.eye = QRCode.EyeShape.RoundedOuter()
            case "eye_roundedpointingin":
                doc.design.shape.eye = QRCode.EyeShape.RoundedPointingIn()
            case "eye_roundedRect":
                doc.design.shape.eye = QRCode.EyeShape.RoundedRect()
            case "eye_squircle":
                doc.design.shape.eye = QRCode.EyeShape.Squircle()
            default:
                print(-1)
            }
        }
    }
    
    func addEyes(_ eyesSelected: String) {
        let qrWithEyes = QRCodeEyes()
        qrWithEyes.eyes = eyesSelected
        realm.beginWrite()
        realm.add(qrWithEyes)
        try! realm.commitWrite()
    }
    
    func updateEyes(_ eyes: QRCodeEyes, _ eyesSelected: String) {
        realm.beginWrite()
        eyes.eyes = eyesSelected
        try! realm.commitWrite()
    }
}

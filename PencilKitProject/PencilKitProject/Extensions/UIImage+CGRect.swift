//
//  UIImage+CGRect.swift
//  PencilKitProject
//
//  Created by gustavo.quenca on 12/06/20.
//  Copyright © 2020 gustavo.quenca. All rights reserved.
//

import UIKit

extension CGRect {
    var center: CGPoint { return CGPoint(x: midX, y: midY) }
}

extension UIImage {
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    
    
    func image(byDrawingImage image: UIImage, inRect rect: CGRect) -> UIImage! {
        UIGraphicsBeginImageContext(size)

        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    func resize(newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    func toCVPixelBuffer() -> CVPixelBuffer? {
       var pixelBuffer: CVPixelBuffer? = nil

        let attr = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
        kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        
       let width = Int(self.size.width)
       let height = Int(self.size.height)

       CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_OneComponent8, attr, &pixelBuffer)
       CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue:0))

       let colorspace = CGColorSpaceCreateDeviceGray()
       let bitmapContext = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer!), width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: colorspace, bitmapInfo: 0)!

       guard let cg = self.cgImage else {
           return nil
       }

       bitmapContext.draw(cg, in: CGRect(x: 0, y: 0, width: width, height: height))

       return pixelBuffer
    }
}


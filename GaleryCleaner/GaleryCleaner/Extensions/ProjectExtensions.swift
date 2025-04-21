//
//  ProjectExtensions.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 11.04.2025.
//

import AVFoundation
import UIKit

extension UIViewController {
    func showDialogWithButtons(title: String? = nil, message: String? = nil, actions: [UIAlertAction], alertStyle: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        let color = UIColor.colorFromHex("#F2F2F2", alpha: 0.8)
        
        alert.setBackgroundColor(color: color)
        alert.setTitleFont(font: UIFont.systemFont(ofSize: 17, weight: .bold), color: .black)
        alert.setMessageFont(font: UIFont.systemFont(ofSize: 13, weight: .regular), color: .black)
       
        actions.forEach { item in
            alert.addAction(item)
        }
        self.present(alert, animated: true)
    }
    func showErrorMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let color = UIColor.colorFromHex("#F2F2F2", alpha: 0.8)
        alert.setBackgroundColor(color: color)
        alert.setTitleFont(font: UIFont.systemFont(ofSize: 17, weight: .bold), color: .black)
        alert.setMessageFont(font: UIFont.systemFont(ofSize: 13, weight: .regular), color: .black)
        let action = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
}
extension UIAlertController {
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
  
    //Set title font and title color
    func setTitleFont(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)//1
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                                          range: NSMakeRange(0, title.utf8.count))
        }
        
        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor],//3
                                          range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")//4
    }
    
    //Set message font and message color
    func setMessageFont(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : messageFont],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        
        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : messageColorColor],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }
    
    //Set tint color of UIAlertController
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}
extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    func createBlurEffect() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }
    enum ViewSide {
         case Left, Right, Top, Bottom, All
     }
    
     func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness width: CGFloat) {
         let border = CALayer()
         border.backgroundColor = color
         switch side {
         case .Left:   border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height); break
         case .Right:  border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height); break
         case .Top: border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width); break
         case .Bottom: border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width); break
         case .All:
             border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
             border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
             border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
             border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
         }
         layer.addSublayer(border)
     }

}
extension UIColor {
    class func colorFromHex(_ color: String, alpha: Double = 1.0) -> UIColor {
        let r, g, b: CGFloat
        
        let start = color.index(color.startIndex, offsetBy: color.hasPrefix("#") ? 1 : 0)
        let hexColor = String(color[start...])
        
        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000FF) / 255
                
                return UIColor.init(red: r, green: g, blue: b, alpha: alpha)
            }
        }

        return UIColor.gray
    }
}
extension UIImage {
    func createMiniture(image: UIImage?, width: Int? = nil, height: Int? = nil) -> UIImage?{
        guard let image = image else { return nil }
        let maxSize = CGSize(width: width ?? 32, height: height ?? 32)
        let availableRect = AVFoundation.AVMakeRect(aspectRatio: image.size, insideRect: .init(origin: .zero, size: maxSize))
        let targetSize = (width != nil && height != nil) ? availableRect.size : maxSize
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)

        let resized = renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        return resized
    }
    func convertToGrayScale(image: UIImage?) -> UIImage? {
        guard let image = image else { return nil }
        let imageRect:CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.draw(image.cgImage!, in: imageRect, byTiling: true)
        let imageRef = context!.makeImage()
        let newImage = UIImage(cgImage: imageRef!)
        return newImage
    }
    func pixelValuesFromImage(imageRef: CGImage?) -> (pixelValues: [UInt8]?, width: Int, height: Int)
    {
        var width = 0
        var height = 0
        var pixelValues: [UInt8]?
        if let imageRef = imageRef {
            let totalBytes = imageRef.width * imageRef.height
            let colorSpace = CGColorSpaceCreateDeviceGray()
            
            pixelValues = [UInt8](repeating: 0, count: totalBytes)
            pixelValues?.withUnsafeMutableBytes({
                width = imageRef.width
                height = imageRef.height
                let contextRef = CGContext(data: $0.baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width, space: colorSpace, bitmapInfo: 0)
                let drawRect = CGRect(x: 0.0, y:0.0, width: CGFloat(width), height: CGFloat(height))
                contextRef?.draw(imageRef, in: drawRect)
            })
        }

        return (pixelValues, width, height)
    }
    func blackWhiteConverter(yourUIImage: UIImage?) -> CGImage?{
        
        guard let currentCGImage = yourUIImage?.cgImage else { return nil}
        let currentCIImage = CIImage(cgImage: currentCGImage)
        
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")
        
        // set a gray value for the tint color
        
        filter?.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor")
        
        filter?.setValue(1.0, forKey: "inputIntensity")
        guard let outputImage = filter?.outputImage else { return nil}
        
        let context = CIContext()
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            print(processedImage.size)
            return cgimg
        } else {
            return nil
        }
    }
}
extension CIImage {
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
            return cgImage
        }
        return nil
    }
}
extension CGImage {
    func pixelValuesFromImage(imageRef: CGImage?) -> (pixelValues: [UInt8]?, width: Int, height: Int)
    {
        var width = 0
        var height = 0
        var pixelValues: [UInt8]?
        if let imageRef = imageRef {
            let totalBytes = imageRef.width * imageRef.height
            let colorSpace = CGColorSpaceCreateDeviceGray()
            
            pixelValues = [UInt8](repeating: 0, count: totalBytes)
            pixelValues?.withUnsafeMutableBytes({
                width = imageRef.width
                height = imageRef.height
                let contextRef = CGContext(data: $0.baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width, space: colorSpace, bitmapInfo: 0)
                let drawRect = CGRect(x: 0.0, y:0.0, width: CGFloat(width), height: CGFloat(height))
                contextRef?.draw(imageRef, in: drawRect)
            })
        }

        return (pixelValues, width, height)
    }
}

extension URL {
     var attributes: [FileAttributeKey : Any]? {
         do {
             return try FileManager.default.attributesOfItem(atPath: path)
         } catch let error as NSError {
             print("FileAttribute error: \(error)")
         }
         return nil
     }

     var fileSize: UInt64 {
         return attributes?[.size] as? UInt64 ?? UInt64(0)
     }

     var fileSizeString: String {
         return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
     }

     var creationDate: Date? {
         return attributes?[.creationDate] as? Date
     }
 }

extension UIApplication {
    
    class
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}


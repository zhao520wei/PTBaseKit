//
//  ImageSource.swift
//  ThinkerBaseKit
//
//  Created by P36348 on 30/01/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import Kingfisher

public enum ImageSourceType {
    case string, url, image, data
}

public protocol ImageSource {
    
    var type: ImageSourceType {get}
    
    var targetSize: CGSize {get}
    
    var css: UIViewCss? {get}
    
    var rawData: ImageRawData {get}
    
    var placeHolder: ImageRawData? {get}
}

extension ImageSource {
    public var targetSize: CGSize {
        return CGSize.zero
    }
}

struct DefaultImageSource: ImageSource {
    
    var placeHolder: ImageRawData? = nil
    
    var type: ImageSourceType
    {
        return self.rawData.type
    }
    
    var css: UIViewCss?
    
    var rawData: ImageRawData
    
    var targetSize: CGSize?
    
    init(rawData: ImageRawData, placeHolder: ImageRawData?, css: UIViewCss?, targetSize: CGSize?) {
        self.rawData = rawData
        self.css = css
        self.placeHolder = placeHolder
        self.targetSize = targetSize
    }
}

public protocol ImageRawData: ImageSource {
    
}

extension ImageRawData {
    
    public var placeHolder: ImageRawData? {
        return self
    }
    
    public func imageSource(placeHolder: ImageRawData? = nil, css: UIViewCss?, targetSize: CGSize? = nil) -> ImageSource {
        return DefaultImageSource(rawData: self, placeHolder: placeHolder, css: css, targetSize: targetSize)
    }
}

public func imageSource(with rawData: ImageRawData, placeHolder: ImageRawData? = nil, css: UIViewCss?, targetSize: CGSize? = nil) -> ImageSource {
    return DefaultImageSource(rawData: rawData, placeHolder: placeHolder, css: css, targetSize: targetSize)
}


extension ImageRawData {
    
    public var css: UIViewCss? {
        return nil
    }
    
    public var rawData: ImageRawData {
        return self
    }
}

extension String: ImageRawData {
    
    public var type: ImageSourceType
    {
        return .string
    }
}

extension URL: ImageRawData {
    public var type: ImageSourceType
    {
        return .url
    }
}

extension UIImage: ImageRawData {
    
    public var targetSize: CGSize {
        return self.size
    }
    
    public var type: ImageSourceType
    {
        return .image
    }
}

extension Data: ImageRawData {
    
    public var type: ImageSourceType
    {
        return .data
    }
}

extension String: Resource {
    public var cacheKey: String {
        return self
    }
    
    public var downloadURL: URL {
        return URL(string: self) ?? URL(string: "https://www.google.com")!
    }
}


public protocol ImageSetable {
    func setupImage(with imageSource: ImageSource?)
}



extension UIButton: ImageSetable {
    
    public func setupImage(with imageSource: ImageSource?) {
        
        guard let source = imageSource else {return self.setImage(nil, for: UIControlState.normal)}
        
        if
            let imageView = self.imageView,
            let css = source.css
        {
            imageView += css
        }
        
        //TODO: Kingfisher 的 UIButton 没有添加loading 菊花
        
        switch
            source.type
        {
        case .string, .url:
            self.kf.setImage(with: source.rawData as? Resource,
                             for: UIControlState.normal,
                             placeholder: imageSource?.placeHolder?.imageValue,
                             options: [.scaleFactor(UIScreen.main.scale)], //图片scale转换
                             progressBlock: nil,
                             completionHandler: nil)
        case .data:
            self.setImage(UIImage(data: (source.rawData as! Data)), for: UIControlState.normal)
        case .image:
            self.setImage(source.rawData as? UIImage, for: UIControlState.normal)
        }
    }
}

extension UIImageView: ImageSetable {
    
    public func setupImage(with imageSource: ImageSource?) {
        
        guard let source = imageSource else {return (self.image = nil)}
        
        if
            let css = source.css
        {
            self += css
        }
        
        self.kf.indicatorType = .activity
        
        switch
            source.type
        {
        case .string, .url:
            self.kf.setImage(with: source.rawData as? Resource,
                             placeholder: source.placeHolder?.imageValue,
                             options: [.scaleFactor(UIScreen.main.scale)],
                             progressBlock: nil,
                             completionHandler: nil)
        case .data:
            self.image = UIImage(data: (source.rawData as! Data))
        case .image:
            self.image = source.rawData as? UIImage
        }
    }
}

extension ImageRawData {
    var imageValue: UIImage? {
        switch self.type {
        case .image:
            return self.rawData as? UIImage
        case .data:
            return UIImage(data: self.rawData as! Data)
        case .url:
            return UIImage(contentsOfFile: (self.rawData as! URL).absoluteString)
        case .string:
            return UIImage(contentsOfFile: self.rawData as! String)
        }
    }
}


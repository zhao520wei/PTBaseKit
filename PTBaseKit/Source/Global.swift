//
//  Global.swift
//  PTBaseKit
//
//  Created by P36348 on 11/11/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit

public struct PTBaseKit {
   public static func setupCss(mainColorHex: Int, normalGradientStartHex: Int, normalGradientEndHex: Int, highlightedGradientStartHex: Int, highlightedGradientEndHex: Int, noticeRedColorHex: Int, emptyHighlightedGradientStartHex: Int, emptyHighlightedGradientEndHex: Int) {
        setup(mainColorHex: mainColorHex, normalGradientStartHex: normalGradientStartHex, normalGradientEndHex: normalGradientEndHex, highlightedGradientStartHex: highlightedGradientStartHex, highlightedGradientEndHex: highlightedGradientEndHex, noticeRedColorHex: noticeRedColorHex, emptyHighlightedGradientStartHex: emptyHighlightedGradientStartHex, emptyHighlightedGradientEndHex: emptyHighlightedGradientEndHex)
    }
    
    public static var buttonRadius: CGFloat = 5
}

extension PTBaseKit {
    public struct Resource {
        
        public static var backIndicatorImage: UIImage? = nil
        
        public static var backIndicatorTransitionMaskImage: UIImage? = nil
        
        public static var webCancelImage: UIImage? = nil
        
        public static var accessory: UIImage? = nil
        
        public static var loadingLogo: UIImage? = nil
        
        public static var emptyImage: UIImage? = nil
        
        public static var alertConfirmTitle: String = "OK"
        
        public static var alertCancelTitle: String = "Cancel"
        
        public static var textFieldDoneTitle: String = "Done"
        
        public static var emptyTips: String = "No Data Yet."
        
        public static var loadingProgressTitle: String = "Loading"
        
        public static var loadingFinishTitle: String = "Finished"
        
    }

}

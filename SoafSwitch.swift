//
//  SoafSwitch.swift
//  SoafSwitch
//
//  Created by 이씨안 on 2018. 5. 8..
//  Copyright © 2018년 SoafSwitch. All rights reserved.
//

import Foundation
import UIKit

@objc
public protocol SoafSwitchDelegate{
    @objc optional func didTouchOn(sender: SoafSwitch)
}

@IBDesignable
public class SoafSwitch: UIView {
    
    let animateDuration: TimeInterval = 0.2695
    
    @IBInspectable public var isOn: Bool = true
    
    @IBInspectable public var barOnColor: UIColor = .clear
    @IBInspectable public var barOnImage: UIImage = UIImage()
    @IBInspectable public var barOffColor: UIColor = .clear
    @IBInspectable public var barOffImage: UIImage = UIImage()
    
    @IBInspectable public var barHeight: CGFloat = 0
    
    @IBInspectable public var barRoundness: CGFloat = 0
    @IBInspectable public var barIsRound: Bool = false
    
    @IBInspectable public var barBorderOnColor: UIColor = .clear
    @IBInspectable public var barBorderOffColor: UIColor = .clear
    @IBInspectable public var barBorderWidth: CGFloat = 0
    
    @IBInspectable public var barShadowColor: UIColor = .clear
    @IBInspectable public var barShadowRadius: CGFloat = 0
    @IBInspectable public var barShadowOpacity: Float = 0
    @IBInspectable public var barShadowOffset: CGSize = CGSize(width: 0, height: 0)
    
    
    @IBInspectable public var thumbOnColor: UIColor = .clear
    @IBInspectable public var thumbOnImage: UIImage = UIImage()
    @IBInspectable public var thumbOffColor: UIColor = .clear
    @IBInspectable public var thumbOffImage: UIImage = UIImage()
    
    @IBInspectable public var thumbSize: CGSize = CGSize()
    
    @IBInspectable public var thumbRoundness: CGFloat = 0
    @IBInspectable public var thumbIsRound: Bool = false
    
    @IBInspectable public var thumbBorderOnColor: UIColor = .clear
    @IBInspectable public var thumbBorderOffColor: UIColor = .clear
    @IBInspectable public var thumbBorderWidth: CGFloat = 0
    
    @IBInspectable public var thumbShadowColor: UIColor = .clear
    @IBInspectable public var thumbShadowRadius: CGFloat = 0
    @IBInspectable public var thumbShadowOpacity: Float = 0
    @IBInspectable public var thumbShadowOffset: CGSize = CGSize(width: 0, height: 0)
    
    //@IBInspectable public var preferVerticalDirection: Bool = false
    //@IBInspectable public var switchDirection: Double = 0
    
    public struct AppearanceSet{
        var onColor: UIColor
        var onImage: UIImage
        var offColor: UIColor
        var offImage: UIImage
        var onBorderColor: UIColor
        var offBorderColor: UIColor
    }
    
    var delegate: SoafSwitchDelegate? = nil
    
    public var bar: UIImageView = UIImageView()
    public var barAppearance: AppearanceSet = AppearanceSet(onColor: .clear, onImage: UIImage(), offColor: .clear, offImage: UIImage(), onBorderColor: UIColor(), offBorderColor: UIColor())
    public var thumb: UIImageView = UIImageView()
    public var thumbAppearance: AppearanceSet = AppearanceSet(onColor: .clear, onImage: UIImage(), offColor: .clear, offImage: UIImage(), onBorderColor: UIColor(), offBorderColor: UIColor())
    
    var actionRecognizer: UIButton = UIButton()
    
    // MARK : First one is left, second one is right.
    var barInscribePoint: (CGPoint, CGPoint) = (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0))
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        actionRecognizer.addTarget(self, action: #selector(self.thumbAction), for: .touchUpInside)
    }
    
    override public func draw(_ rect: CGRect) {
        actionRecognizer.frame = rect
        
        var barMargin: CGFloat = 0
        
        if thumbSize.width > barHeight{
            barMargin += thumbSize.width - barHeight
        }
        
        self.bar = UIImageView(frame: getBarRect(fitsIn: rect, with: barHeight, with: barMargin))
        self.barAppearance = AppearanceSet(
            onColor: self.barOnColor,
            onImage: self.barOnImage,
            offColor: self.barOffColor,
            offImage: self.barOffImage,
            onBorderColor: self.barBorderOnColor,
            offBorderColor: self.barBorderOffColor)
        
        if self.barIsRound {
            bar.layer.cornerRadius = bar.frame.height/2
        }else{
            if self.barRoundness*2 < rect.height && self.barRoundness >= 0{
                bar.layer.cornerRadius = self.barRoundness
            }else if barRoundness < 0{
                //nothing to do
            }else{
                bar.layer.cornerRadius = bar.frame.height/2
            }
        }
        
        barInscribePoint = (
            CGPoint(x: bar.frame.minX + bar.frame.height/2, y: bar.frame.minY + bar.frame.height/2),
            CGPoint(x: bar.frame.maxX - bar.frame.height/2 , y: bar.frame.maxY - bar.frame.height/2)
        )
        
        bar.layer.borderWidth = self.barBorderWidth
        
        bar.layer.shadowRadius = self.barShadowRadius
        bar.layer.shadowColor = self.barShadowColor.cgColor
        bar.layer.shadowOffset = self.barShadowOffset
        bar.layer.shadowOpacity = self.barShadowOpacity
        
        if isOn{
            self.thumb = UIImageView(frame: CGRect(x: barInscribePoint.1.x - thumbSize.width/2, y: (rect.height - thumbSize.height)/2, width: thumbSize.width, height: thumbSize.height))
        }else{
            self.thumb = UIImageView(frame: CGRect(x: barInscribePoint.0.x - thumbSize.width/2, y: (rect.height - thumbSize.height)/2, width: thumbSize.width, height: thumbSize.height))
        }
        
        
        if thumbIsRound {
            thumb.layer.cornerRadius = thumb.frame.height/2
        }else{
            if self.thumbRoundness*2 < rect.height && self.thumbRoundness >= 0{
                thumb.layer.cornerRadius = thumbRoundness
            }else if thumbRoundness < 0{
                //nothing to do
            }else{
                thumb.layer.cornerRadius = thumb.frame.height/2
            }
        }
        
        self.thumbAppearance = AppearanceSet(
            onColor: self.thumbOnColor,
            onImage: self.thumbOnImage,
            offColor: self.thumbOffColor,
            offImage: self.thumbOffImage,
            onBorderColor: self.thumbBorderOnColor,
            offBorderColor: self.thumbBorderOffColor)
        
        setColors()
        
        thumb.layer.borderWidth = self.thumbBorderWidth
        
        thumb.layer.shadowRadius = self.thumbShadowRadius
        thumb.layer.shadowColor = self.thumbShadowColor.cgColor
        thumb.layer.shadowOffset = self.thumbShadowOffset
        thumb.layer.shadowOpacity = self.thumbShadowOpacity
        
        self.thumb.clipsToBounds = false
        self.thumb.layer.masksToBounds = false
        
        self.addSubview(bar)
        self.addSubview(thumb)
        self.addSubview(actionRecognizer)
    }
    
    @objc private func thumbAction(){
        let thumbMoveOffset = barInscribePoint.1.x - barInscribePoint.0.x
        
        if !isOn{
            UIView.animate(withDuration: animateDuration, delay: 0, options: [.curveEaseInOut], animations: {
                self.thumb.frame.origin.x = self.thumb.frame.origin.x + thumbMoveOffset
            }, completion: nil)
            isOn = true
        }else{
            UIView.animate(withDuration: animateDuration, delay: 0, options: [.curveEaseInOut], animations: {
                self.thumb.frame.origin.x = self.thumb.frame.origin.x - thumbMoveOffset
            }, completion: nil)
            isOn = false
        }
        
        setColors()
        
        delegate?.didTouchOn!(sender: self)
    }
    
    private func getBarRect(fitsIn rect: CGRect, with height: CGFloat, with margin: CGFloat) -> CGRect{
        var barRectWidth: CGFloat
        var barRectHeight: CGFloat
        var barXPosition: CGFloat
        var barYPosition: CGFloat
        
        if height < rect.height && !(height <= 0){
            barYPosition = (rect.height - height)/2
            barRectHeight = height
        }else{
            barRectHeight = rect.height
            barYPosition = 0
        }
        
        if margin*2 < rect.width && !(margin <= 0){
            barXPosition = margin
            barRectWidth = rect.width - (margin*2)
        }else{
            barRectWidth = rect.width
            barXPosition = 0
        }
        
        return CGRect(x: barXPosition, y: barYPosition, width: barRectWidth, height: barRectHeight)
    }
    
    private func setColors(){
        
        animateBorderTransition()
        
        if isOn{
            UIView.animate(withDuration: animateDuration, delay: 0, options: [.curveEaseInOut], animations: {
                self.bar.backgroundColor = self.barAppearance.onColor
                self.bar.image = self.barAppearance.onImage
                
                self.thumb.backgroundColor = self.thumbAppearance.onColor
                self.thumb.image = self.thumbAppearance.onImage
            }, completion: nil)
            
            self.bar.layer.borderColor = self.barAppearance.onBorderColor.cgColor
            self.thumb.layer.borderColor = self.thumbAppearance.onBorderColor.cgColor
            
        }else{
            UIView.animate(withDuration: animateDuration, delay: 0, options: [.curveEaseInOut], animations: {
                self.bar.backgroundColor = self.barAppearance.offColor
                self.bar.image = self.barAppearance.offImage
                self.bar.layer.borderColor = self.barAppearance.offBorderColor.cgColor
                self.thumb.backgroundColor = self.thumbAppearance.offColor
                self.thumb.image = self.thumbAppearance.offImage
                self.thumb.layer.borderColor = self.thumbAppearance.offBorderColor.cgColor
            }, completion: nil)
            
            self.bar.layer.borderColor = self.barAppearance.offBorderColor.cgColor
            self.thumb.layer.borderColor = self.thumbAppearance.offBorderColor.cgColor
        }
    }
    private func animateBorderTransition(){
        let barBorderColor: CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        let thumbBorderColor: CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        
        //            let borderWidth:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        //            borderWidth.fromValue = 0
        //            borderWidth.toValue = 0.9
        //            borderWidth.duration = 0.5
        //            yourView.layer.borderWidth = 0.5
        //            yourView.layer.borderColor = UIColor.whiteColor().CGColor
        //            yourView.layer.addAnimation(borderWidth, forKey: "Width")
        //            yourView.layer.borderWidth = 0.0
        
        if isOn{
            barBorderColor.fromValue = barAppearance.onBorderColor
            barBorderColor.toValue = barAppearance.offBorderColor
            barBorderColor.duration = animateDuration
            thumbBorderColor.fromValue = thumbAppearance.onBorderColor
            thumbBorderColor.toValue = thumbAppearance.offBorderColor
            thumbBorderColor.duration = animateDuration
            
            bar.layer.add(barBorderColor, forKey: "Color")
            thumb.layer.add(thumbBorderColor, forKey: "Color")
        }else{
            barBorderColor.fromValue = barAppearance.offBorderColor
            barBorderColor.toValue = barAppearance.onBorderColor
            barBorderColor.duration = animateDuration
            thumbBorderColor.fromValue = thumbAppearance.offBorderColor
            thumbBorderColor.toValue = thumbAppearance.onBorderColor
            thumbBorderColor.duration = animateDuration
            
            bar.layer.add(barBorderColor, forKey: "Color")
            thumb.layer.add(thumbBorderColor, forKey: "Color")
        }
    }
}

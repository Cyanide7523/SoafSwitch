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
    @IBInspectable public var isEnabled: Bool = true
    
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
    
    
    
    public enum SwitchObject{
        case bar
        case thumb
    }
    
    public struct AppearanceSet{
        public var onColor: UIColor
        public var onImage: UIImage
        public var offColor: UIColor
        public var offImage: UIImage
        public var onBorderColor: UIColor
        public var offBorderColor: UIColor
        
        public init(on: UIColor, off: UIColor){
            onColor = on
            offColor = off
            onImage = UIImage()
            offImage = UIImage()
            onBorderColor = .clear
            offBorderColor = .clear
        }
        public init(on: UIImage, off: UIImage) {
            onColor = .clear
            offColor = .clear
            onImage = on
            offImage = off
            onBorderColor = .clear
            offBorderColor = .clear
        }
        public init(borderOn on: UIColor, off: UIColor){
            onColor = .clear
            offColor = .clear
            onImage = UIImage()
            offImage = UIImage()
            onBorderColor = on
            offBorderColor = off
        }
        public init(on: UIColor, off: UIColor, onBorder: UIColor, offBorder: UIColor){
            onColor = on
            offColor = off
            onImage = UIImage()
            offImage = UIImage()
            onBorderColor = onBorder
            offBorderColor = offBorder
        }
        public init(on: UIImage, off: UIImage, onBorder: UIColor, offBorder: UIColor){
            onColor = .clear
            offColor = .clear
            onImage = on
            offImage = off
            onBorderColor = onBorder
            offBorderColor = offBorder
        }
        public init(onColor: UIColor, onImage: UIImage, offColor: UIColor, offImage: UIImage, onBorderColor: UIColor, offBorderColor: UIColor){
            self.onColor = onColor
            self.offColor = offColor
            self.onImage = onImage
            self.offImage = offImage
            self.onBorderColor = onBorderColor
            self.offBorderColor = offBorderColor
        }
    }
    
    public struct ShadowAppearanceSet{
        public var color: UIColor
        public var radius: CGFloat
        public var opacity: Float
        public var offset: CGSize
    }
    
    public var delegate: SoafSwitchDelegate? = nil
    
    public var bar: UIImageView = UIImageView()
    public var barAppearance: AppearanceSet = AppearanceSet(onColor: .clear, onImage: UIImage(), offColor: .clear, offImage: UIImage(), onBorderColor: .clear, offBorderColor: .clear)
    public var thumb: UIImageView = UIImageView()
    public var thumbAppearance: AppearanceSet = AppearanceSet(onColor: .clear, onImage: UIImage(), offColor: .clear, offImage: UIImage(), onBorderColor: .clear, offBorderColor: .clear)
    
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
        
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        
        var barMargin: CGFloat = 0
        
        if thumbSize.width > barHeight{
            barMargin = thumbSize.width - barHeight
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
        
        updateColors()
        
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
        
        updateColors()
        
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
            barXPosition = margin/2
            barRectWidth = rect.width - (margin)
        }else{
            barRectWidth = rect.width
            barXPosition = 0
        }
        
        return CGRect(x: barXPosition, y: barYPosition, width: barRectWidth, height: barRectHeight)
    }
    
    /**
     Apply new color appearance setting for switch.
     */
    public func setAppearance(set: AppearanceSet, at object: SwitchObject){
        DispatchQueue.main.async {
            switch object{
            case .bar:
                self.barAppearance = set
            case .thumb:
                self.thumbAppearance = set
            }
            self.updateColors()
        }
    }
    
    /**
     Apply new shadow appearance setting for switch.
     */
    public func setAppearance(shadow appearance: ShadowAppearanceSet, at object: SwitchObject){
        DispatchQueue.main.async {
            switch object {
            case .bar:
                self.barShadowColor = appearance.color
                self.barShadowOffset = appearance.offset
                self.barShadowRadius = appearance.radius
                self.barShadowOpacity = appearance.opacity
            case .thumb:
                self.thumbShadowColor = appearance.color
                self.thumbShadowOffset = appearance.offset
                self.thumbShadowRadius = appearance.radius
                self.thumbShadowOpacity = appearance.opacity
            }
            
            self.updateShadow()
        }
        
    }
    
    public func setThumbSize(_ size: CGSize){
        DispatchQueue.main.async {
            self.thumbSize = size
            self.thumb.frame.size = size
            
            if self.isOn{
                self.thumb.frame = CGRect(x: self.barInscribePoint.1.x - (size.width/2), y: self.barInscribePoint.1.y - (size.height/2), width: self.thumb.frame.size.width, height: self.thumb.frame.size.height)
            }else{
                self.thumb.frame = CGRect(x: self.barInscribePoint.1.x - (size.width/2), y: self.barInscribePoint.1.y - (size.height/2), width: self.thumb.frame.size.width, height: self.thumb.frame.size.height)
            }
        }
    }
    
    public func setBarHeight(to height: CGFloat){
        DispatchQueue.main.async {
            self.barHeight = height
            
            var barMargin: CGFloat = 0
            
            if self.thumbSize.width > self.barHeight{
                barMargin += self.thumbSize.width - self.barHeight
            }
            
            self.bar.frame = self.getBarRect(fitsIn: self.frame, with: self.barHeight, with: barMargin)
            
            self.barInscribePoint = (
                CGPoint(x: self.bar.frame.minX + self.bar.frame.height/2, y: self.bar.frame.minY + self.bar.frame.height/2),
                CGPoint(x: self.bar.frame.maxX - self.bar.frame.height/2, y: self.bar.frame.maxY - self.bar.frame.height/2)
            )
            
            if self.isOn{
                self.thumb.frame = CGRect(origin: CGPoint(x: self.barInscribePoint.1.x - self.thumbSize.width/2, y: self.barInscribePoint.1.y - self.thumbSize.height/2), size: self.thumb.frame.size)
            }else{
                self.thumb.frame = CGRect(origin: CGPoint(x: self.barInscribePoint.0.x - self.thumbSize.width/2, y: self.barInscribePoint.0.y
                    - self.thumbSize.height/2), size: self.thumb.frame.size)
            }
        }
    }
    
    public func setRoundness(isRound: Bool, at object: SwitchObject){
        DispatchQueue.main.async {
            if isRound{
                switch object{
                case .bar:
                    self.barIsRound = true
                    self.bar.layer.cornerRadius = self.bar.frame.height/2
                case .thumb:
                    self.thumbIsRound = true
                    self.thumb.layer.cornerRadius = self.thumb.frame.height/2
                }
            }
        }
    }
    
    public func setRoundness(roundness: CGFloat, at object: SwitchObject){
        DispatchQueue.main.async {
            switch object {
            case .bar:
                if roundness*2 < self.bar.frame.height && roundness >= 0{
                    self.bar.layer.cornerRadius = roundness
                }else if self.barRoundness < 0{
                    self.bar.layer.cornerRadius = 0
                }else{
                    self.bar.layer.cornerRadius = self.bar.frame.height/2
                }
            case .thumb:
                if roundness*2 < self.thumb.frame.height && roundness >= 0{
                    self.thumb.layer.cornerRadius = roundness
                }else if self.barRoundness < 0{
                    self.thumb.layer.cornerRadius = 0
                }else{
                    self.thumb.layer.cornerRadius = self.thumb.frame.height/2
                }
            }
        }
    }
    
    public func setBorder(width: CGFloat, at object: SwitchObject){
        DispatchQueue.main.async {
            switch object {
            case .bar:
                self.barBorderWidth = width
                self.bar.layer.borderWidth = width
            case .thumb:
                self.thumbBorderWidth = width
                self.thumb.layer.borderWidth = width
            }
        }
    }
    
    public func setState(state: Bool, animated: Bool){
        DispatchQueue.main.async {
            
            let thumbMoveOffset = self.barInscribePoint.1.x - self.barInscribePoint.0.x
            
            self.isOn = state
            
            if animated{
                if self.isOn{
                    UIView.animate(withDuration: self.animateDuration, delay: 0, options: [.curveEaseInOut], animations: {
                    self.thumb.frame.origin.x = self.thumb.frame.origin.x + thumbMoveOffset
                    }, completion: nil)
                }else{
                    UIView.animate(withDuration: self.animateDuration, delay: 0, options: [.curveEaseInOut], animations: {
                    self.thumb.frame.origin.x = self.thumb.frame.origin.x - thumbMoveOffset
                    }, completion: nil)
                }
            }else{
                
                if self.isOn{
                    self.thumb.frame.origin.x = self.thumb.frame.origin.x + thumbMoveOffset
                }else{
                    self.thumb.frame.origin.x = self.thumb.frame.origin.x - thumbMoveOffset
                }
                self.updateColors()
            }
        }
    }
    
    public func setState(enabled: Bool){
        actionRecognizer.isEnabled = enabled
    }
    
    public func addTarget(target: Any?, action: Selector, for events: UIControlEvents){
        self.actionRecognizer.addTarget(target, action: action, for: events)
    }
    
    private func updateShadow(){
        bar.layer.shadowRadius = self.barShadowRadius
        bar.layer.shadowColor = self.barShadowColor.cgColor
        bar.layer.shadowOffset = self.barShadowOffset
        bar.layer.shadowOpacity = self.barShadowOpacity
        
        thumb.layer.shadowRadius = self.thumbShadowRadius
        thumb.layer.shadowColor = self.thumbShadowColor.cgColor
        thumb.layer.shadowOffset = self.thumbShadowOffset
        thumb.layer.shadowOpacity = self.thumbShadowOpacity
    }
    
    private func updateColors(){
        
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

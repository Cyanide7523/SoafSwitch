//
//  ViewController.swift
//  SoafSwitch
//
//  Created by Cyanide7523 on 05/10/2018.
//  Copyright (c) 2018 Cyanide7523. All rights reserved.
//

import UIKit
import SoafSwitch

class ViewController: UIViewController, SoafSwitchDelegate {
    
    @IBOutlet weak var firstSwitch: SoafSwitch!
    @IBOutlet weak var secondSwitch: SoafSwitch!
    @IBOutlet weak var thirdSwitch: SoafSwitch!
    
    @IBOutlet weak var actionSwitch: SoafSwitch!
    @IBOutlet weak var delegateSwitch: SoafSwitch!
    
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var delegateLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        setTheme()
        
        actionSwitch.addTarget(target: self, action: #selector(touchedActionSwtich), for: .touchUpInside)
        delegateSwitch.delegate = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //Performs with addTarget() function
    @objc func touchedActionSwtich(){
        if actionSwitch.isOn{
            actionLabel.text = "ON"
        }else{
            actionLabel.text = "OFF"
        }
        refreshButtonState()
    }
    
    //Delegate function
    func didTouchOn(sender: SoafSwitch) {
        if sender.isOn{
            delegateLabel.text = "ON"
        }else{
            delegateLabel.text = "OFF"
        }
        refreshButtonState()
    }
    
    func refreshButtonState(){
        if delegateSwitch.isOn && actionSwitch.isOn{
            button.isEnabled = true
            button.backgroundColor = UIColor(red: 241/255, green: 195/255, blue: 36/255, alpha: 1)
            button.titleLabel?.textColor = .darkGray
        }else{
            button.isEnabled = false
            button.backgroundColor = .lightGray
            button.titleLabel?.textColor = .gray
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setTheme(){
        firstSwitch.setState(state: true, animated: false)
        firstSwitch.setAppearance(set: .init(on: .red, off: .lightGray), at: .bar)
        firstSwitch.setAppearance(set: .init(on: .white, off: .white), at: .thumb)
        firstSwitch.setThumbSize(CGSize(width: 20, height: 20))
        firstSwitch.setRoundness(isRound: true, at: .bar)
        firstSwitch.setRoundness(isRound: true, at: .thumb)
        
        secondSwitch.setState(state: true, animated: false)
        secondSwitch.setAppearance(set: .init(on: UIColor(red: 0.3, green: 0.695, blue: 1, alpha: 1), off: .lightGray), at: .bar)
        secondSwitch.setAppearance(set: .init(on: #imageLiteral(resourceName: "thumbImage"), off: #imageLiteral(resourceName: "thumbImage")), at: .thumb)
        secondSwitch.setThumbSize(CGSize(width: 20, height: 20))
        secondSwitch.setBarHeight(to: 4)
        secondSwitch.setRoundness(isRound: true, at: .bar)
        
        thirdSwitch.setState(state: true, animated: false)
        let thirdSwitchColor = UIColor(red: 0.9632, green: 0.4732, blue: 0.5122, alpha: 1)
        thirdSwitch.setAppearance(set: .init(on: .white, off: .white, onBorder: thirdSwitchColor, offBorder: .lightGray), at: .bar)
        thirdSwitch.setAppearance(set: .init(on: thirdSwitchColor, off: .lightGray), at: .thumb)
        thirdSwitch.setBorder(width: 1.5, at: .bar)
        thirdSwitch.setThumbSize(CGSize(width: 25, height: 25))
        
    }
}


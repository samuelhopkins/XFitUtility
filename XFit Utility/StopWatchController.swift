//
//  StopWatchController.swift
//  XFitStopWatch
//
//  Created by Hopkins, Sam on 6/19/15.
//  Copyright (c) 2015 Hopkins, Sam. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
class StopWatchController: UIViewController {

    override func viewDidLoad() {
        IntervalValue.wraps = true
        IntervalValue.autorepeat = true
        IntervalValue.maximumValue = 20
        OffValue.wraps = true
        OffValue.autorepeat = true
        OffValue.maximumValue = 20
        Micros.text=String(format:"%02d",MicroCounter)
        Seconds.text=String(format: "%02d",SecondCounter)
        Minutes.text=String(format: "%02d",MinuteCounter)
        SecondCounter = 0
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var Micros: UILabel!

    @IBOutlet weak var Seconds: UILabel!
    @IBOutlet weak var Minutes: UILabel!
    
    @IBOutlet weak var IntervalValue: UIStepper!
    
    @IBOutlet weak var OffValue: UIStepper!
    
    @IBOutlet weak var IntervalLabel: UILabel!
    @IBOutlet weak var OffLabel: UILabel!
    @IBOutlet weak var TimeOn: UILabel!
    
    
    @IBOutlet weak var StartStop: StartButtonClass!
    
    @IBOutlet weak var TabataButton: StartButtonClass!
    @IBOutlet weak var TimeOff: UILabel!
    
    @IBOutlet weak var TimeView: UIView!
    @IBOutlet weak var StepperView: UIView!
    @IBOutlet weak var ButtonView: UIView!
    
    var Timer:NSTimer = NSTimer()
    var started = false
    var offBool = false
    var tabata = false
    var tenCount = true
    var offDiff:Float = 0
    var Off:Float = 0
    var MicroCounter = 0
    var SecondCounter = 0
    var MinuteCounter : Float = 0
    var Interval:Float = 0
    var MyRed = UIColor(red: 192/255, green: 29/255, blue: 27/255, alpha: 1.0)
    var intervalTotal = 0
    var offTotal = 0
    let myBlue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
    let myDarkerBlue = UIColor(red: 150/255, green: 122/255, blue: 255/255, alpha: 1.0)
    @IBAction func Reset(sender: AnyObject) {
        Timer.invalidate()
        MicroCounter=0
        SecondCounter=0
        MinuteCounter=0
        Micros.text=String(format:"%02d",MicroCounter)
        Seconds.text=String(format: "%02d",SecondCounter)
        Minutes.text=String(format: "%02d",MinuteCounter)
        started = false
        StartStop.setTitle("Start", forState: .Normal)
        StartStop.isStop = false
        TimeOn.textColor = UIColor.whiteColor()
    }
    
    @IBAction func StartOrStop(sender: AnyObject) {
        print(StartStop.isStop)
        if (StartStop.isStop == false){
        if (!started){
            TimeOn.textColor = myBlue
        Timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("UpdateTimer"), userInfo: nil, repeats: true)
        started = true
            StartStop.isStop = true
            StartStop.setTitle("Stop", forState: .Normal)
        }
        }
        else{
            Timer.invalidate()
            started = false
            tabata = false
            StartStop.setTitle("Start", forState: .Normal)
            StartStop.isStop = false
 
        }
    }
    
    
    @IBAction func StartTabata(sender: StartButtonClass) {
        if !(started || tabata){
        tabata = true
        TimeOn.textColor = UIColor.whiteColor()
        Timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("UpdateTimer"), userInfo: nil, repeats: true)
        started = true
        StartStop.isStop = true
        StartStop.setTitle("Stop", forState: .Normal)
        }
    }
    
    
    func UpdateTimer(){
        if (tabata){
            if (MicroCounter % 99 == 0) && (MicroCounter != 0){
                MicroCounter = 0
                 Micros.text = String(format: "%02d",MicroCounter)
                 Seconds.text = String(format: "%02d",++SecondCounter)
                if (tenCount){
                if(SecondCounter % 10 == 0){
                    tenCount = false
                    SecondCounter = 0
                    Seconds.text=String(format: "%02d",SecondCounter)
                    TabataIntervalSound()
                }
                }
                else if(SecondCounter % 20 == 0){
                SecondCounter = 0
                tenCount = true
                Seconds.text=String(format: "%02d",SecondCounter)
                TabataIntervalSound()
                }
            }
            else {
                
                 MicroCounter+=1
                 Micros.text = String(format: "%02d",MicroCounter)
            }
        }
        else{
        if (MicroCounter % 99 == 0) && (MicroCounter != 0)
        {
            MicroCounter = 0
             Micros.text = String(format: "%02d",MicroCounter)
            Seconds.text = String(format: "%02d",++SecondCounter)
        
           if(SecondCounter % 60 == 0)
           {
            SecondCounter=0
            Seconds.text=String(format: "%02d",SecondCounter)
            
            Minutes.text=String(format: "%02.0f",++MinuteCounter)
           
            IntervalSound(MinuteCounter)
            }
            else if(SecondCounter % 30 == 0)
           {
            IntervalSound(MinuteCounter + 0.5)
            }
            }
        else{
            MicroCounter+=1
            Micros.text = String(format: "%02d",MicroCounter)
            }
        }
    }
    
    @IBAction func StepperChange(sender: UIStepper) {
        let sentVal = Float(sender.value)
        IntervalLabel.text = String(format: "%.1f", sentVal) + "min"
        Interval = sentVal
    }
    
    @IBAction func OffChange(sender: UIStepper) {
        let sent = Float(sender.value)
        OffLabel.text = String(format: "%.1f", sent) + "min"
        Off = sent
    }
    
    func TabataIntervalSound(){
        if (tenCount){
            AudioServicesPlayAlertSound(1023)
            TimeOff.textColor = myDarkerBlue
            TimeOn.textColor = UIColor.whiteColor()
            self.view.backgroundColor = MyRed
            Micros.textColor = UIColor.blackColor()
            Seconds.textColor = UIColor.blackColor()
            Minutes.textColor = UIColor.blackColor()
            IntervalValue.tintColor = UIColor.blackColor()
            OffValue.tintColor = UIColor.blackColor()
            StepperView.backgroundColor = MyRed
            TimeView.backgroundColor = MyRed
            ButtonView.backgroundColor = MyRed

                   }
        else{
            AudioServicesPlayAlertSound(1023)
            TimeOff.textColor = UIColor.whiteColor()
            TimeOn.textColor = myBlue
            self.view.backgroundColor = UIColor.blackColor()
            Micros.textColor = MyRed
            Seconds.textColor = MyRed
            Minutes.textColor = MyRed
            
            IntervalValue.tintColor = myBlue
            OffValue.tintColor = myBlue
            StepperView.backgroundColor = UIColor.blackColor()
            TimeView.backgroundColor = UIColor.blackColor()
            ButtonView.backgroundColor = UIColor.blackColor()
                   }
    }
    
    func IntervalSound(value: Float){
        if (offBool)
        {
            offDiff += 0.5
            if (offDiff == Off)
            {
                offDiff = 0
                offBool = false
                
                AudioServicesPlayAlertSound(1023)
                ChangeColors()
                        }
        }
        
        else if (Interval > 0)
        {
            if (value % Interval == 0)
            {
        AudioServicesPlayAlertSound(1023)
               
            if (Off > 0){
                offBool = true
                ChangeColors()
            }
            }
        }
    }
    
    func ChangeColors(){
        if (offBool){
            TimeOff.textColor = myDarkerBlue
            TimeOn.textColor = UIColor.whiteColor()
        self.view.backgroundColor = MyRed
        Micros.textColor = UIColor.blackColor()
        Seconds.textColor = UIColor.blackColor()
        Minutes.textColor = UIColor.blackColor()
        IntervalValue.tintColor = UIColor.blackColor()
        OffValue.tintColor = UIColor.blackColor()
        StepperView.backgroundColor = MyRed
        TimeView.backgroundColor = MyRed
        ButtonView.backgroundColor = MyRed
   
        }
        else {
            TimeOff.textColor = UIColor.whiteColor()
            TimeOn.textColor = myBlue
            self.view.backgroundColor = UIColor.blackColor()
            Micros.textColor = MyRed
            Seconds.textColor = MyRed
            Minutes.textColor = MyRed
            
            IntervalValue.tintColor = myBlue
            OffValue.tintColor = myBlue
            StepperView.backgroundColor = UIColor.blackColor()
            TimeView.backgroundColor = UIColor.blackColor()
            ButtonView.backgroundColor = UIColor.blackColor()

        }
    }
}










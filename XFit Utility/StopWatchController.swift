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
        IntervalValue.maximumValue = 600
        OffValue.wraps = true
        OffValue.autorepeat = true
        OffValue.maximumValue = 600
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
    
    @IBOutlet weak var CountDownView: UIView!
    @IBOutlet weak var CountDownLabel: UILabel!
    @IBOutlet weak var TimeView: UIView!
    @IBOutlet weak var StepperView: UIView!
    @IBOutlet weak var ButtonView: UIView!
    @IBOutlet weak var TimeOnSlider: UISlider!
    
    var Timer:NSTimer = NSTimer()
    var CountDownTimer:NSTimer = NSTimer()
    var CountDown:Int = 11
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
        TimeOff.textColor = UIColor.whiteColor()
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
    
    func StartTimer() {
            if TimeOff.textColor == UIColor.whiteColor(){
            TimeOn.textColor = myBlue
        }
        Timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("UpdateTimer"), userInfo: nil, repeats: true)
            StartStop.isStop = true
            StartStop.setTitle("Stop", forState: .Normal)
    }
    
    
    func StartTabata() {
        Interval = 0.2
        Off = 0.1
        IntervalLabel.text = String(format: "%dsec", 20)
            OffLabel.text = String(format: "%dsec", 10)
        TimeOn.textColor = myBlue
        AudioServicesPlayAlertSound(1023)
        Timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("UpdateTimer"), userInfo: nil, repeats: true)
        started = true
        StartStop.isStop = true
        StartStop.setTitle("Stop", forState: .Normal)
    }
    
    @IBAction func StartTabataCountDown(sender: StartButtonClass){
        if (StartStop.isStop == false){
        if !(started){
            if sender.isTabata{
                tabata = true
            }
        MinuteCounter = 0
        SecondCounter = 0
        MicroCounter = 0
        Minutes.text = String(format: "%02.0f", MinuteCounter)
        Seconds.text = String(format: "%02d", SecondCounter)
        Micros.text = String(format: "%02d", MicroCounter)
        CountDownView.hidden = false
        started = true
        CountDownTimer = NSTimer.scheduledTimerWithTimeInterval(0.50, target: self, selector: Selector("UpdateCountDownTimer"), userInfo: nil, repeats: true)
        }
        }
        else{
            Timer.invalidate()
            started = false
            CountDown = 11
            EvenOdd = false
            StartStop.setTitle("Start", forState: .Normal)
            StartStop.isStop = false
            tabata = false
            
        }

    }
    
    var EvenOdd: Bool = false
    
    func UpdateCountDownTimer(){
        if !(EvenOdd){
        EvenOdd = !EvenOdd
        --CountDown
        CountDownLabel.text = String(format: "%d", CountDown)
        print(CountDown)
        if CountDown == 0{
            CountDownTimer.invalidate()
            CountDownView.hidden = true
            if tabata{
            StartTabata()
            }
            else{
            StartTimer()
            }
        }
        else if CountDown < 6{
            AudioServicesPlayAlertSound(1022)
        }
        }
        else{
          EvenOdd = !EvenOdd
          CountDownLabel.text = nil
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
            else if(SecondCounter % 10 == 0)
           {
            print("mod 10")
            print(SecondCounter)
            print(Float(Float(SecondCounter) / 100))
            IntervalSound(MinuteCounter + Float(Float(SecondCounter) / 100))
            }
            }
        else{
            MicroCounter+=1
            Micros.text = String(format: "%02d",MicroCounter)
            }
        }
    }
    
    @IBAction func StepperChange(sender: UIStepper) {
        let TimeOnVal = Int(sender.value)
        let minutes : Int = TimeOnVal / 60
        let Seconds = TimeOnVal
        if minutes == 0{
            IntervalLabel.text = String(format: "%d", Seconds) + "sec"
            Interval = Float(Float(TimeOnVal) / 100)
        }
        else{
            let Seconds = Seconds - (minutes * 60)
            IntervalLabel.text = String(format: "%dmin %dsec", minutes, Seconds)
            Interval = Float(minutes) + Float(Float(Seconds) / 100)
        }
        
    }
    
    
    
    @IBAction func OffChange(sender: UIStepper) {
        let TimeOffVal = Int(sender.value)
        print(TimeOffVal)
        let minutes : Int = TimeOffVal / 60
        let Seconds = TimeOffVal
        if minutes == 0{
            OffLabel.text = String(format: "%d", Seconds) + "sec"
            Off = Float(Float(TimeOffVal) / 100)
        }
        else{
            let Seconds = Seconds - (minutes * 60)
            OffLabel.text = String(format: "%dmin %dsec", minutes, Seconds)
            Off = Float(minutes) + Float(Float(Seconds) / 100)
        }

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
    var offDiffSeconds : Float = 0
    
    func IntervalSound(value: Float){
        print("Interval sound value is ",value)
        print ("Interval is", Interval)
        print(offBool)
        if (offBool)
        {
            offDiffSeconds += 0.1
            offDiff += 0.1
            if offDiffSeconds == 0.6{
                offDiff += 0.4
                offDiffSeconds = 0
                
            }
            if (offDiff == Off)
            {
                offDiff = 0
                offDiffSeconds = 0
                offBool = false
                
                AudioServicesPlayAlertSound(1023)
                ChangeColors()
                        }
        }
        
        else if (Interval > 0.0)
        {
            print("Interval mod is",Int(100*value) % Int(100*Interval))
            print(value*100)
            print(Interval*100)
            if (Int(100*value) % Int(100*Interval) == 0.0)
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










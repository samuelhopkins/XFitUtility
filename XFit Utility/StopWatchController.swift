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
    
    @IBOutlet weak var TimeOff: UILabel!
    
    var Timer:NSTimer = NSTimer()
    var started = false
    var offBool = false
    var offDiff:Float = 0
    var Off:Float = 0
    var MicroCounter = 0
    var SecondCounter = 0
    var MinuteCounter : Float = 0
    var Interval:Float = 0
    var MyRed = UIColor(red: 192/255, green: 29/255, blue: 27/255, alpha: 1.0)
    var intervalTotal = 0
    var offTotal = 0
    var url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Air Horn-SoundBible.com-964603082", ofType: "wav")! )
    var audioPlayer = AVAudioPlayer()
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
    }
    
    @IBAction func StartOrStop(sender: AnyObject) {
        println(StartStop.isStop)
        if (StartStop.isStop == false){
        println(started)
        if (!started){
            TimeOn.textColor = MyRed
        Timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("UpdateTimer"), userInfo: nil, repeats: true)
        started = true
            StartStop.isStop = true
            StartStop.setTitle("Stop", forState: .Normal)
        }
        }
        else{
            Timer.invalidate()
            started = false
            StartStop.setTitle("Start", forState: .Normal)
            StartStop.isStop = false
 
        }
    }
    
    func UpdateTimer(){
        MicroCounter+=1
        Micros.text = String(format: "%02d",MicroCounter)
        if (MicroCounter % 99 == 0)
        {
            MicroCounter = 0
            Seconds.text = String(format: "%02d",++SecondCounter)
        
           if(SecondCounter % 60 == 0)
           {
            SecondCounter=0
            Seconds.text=String(format: "%02d",SecondCounter)
            println("Increment Minutes")
            Minutes.text=String(format: "%02.0f",++MinuteCounter)
            println(MinuteCounter)
            IntervalSound(MinuteCounter)
            }
            else if(SecondCounter % 30 == 0)
           {
            IntervalSound(MinuteCounter + 0.5)
            }
        }
        
    }
    
    @IBAction func StepperChange(sender: UIStepper) {
        var sentVal = Float(sender.value)
        println(sender.value)
        IntervalLabel.text = String(format: "%.1f", sentVal)
        Interval = sentVal
    }
    
    @IBAction func OffChange(sender: UIStepper) {
        var sent = Float(sender.value)
        OffLabel.text = String(format: "%.1f", sent)
        Off = sent
    }
    
    func IntervalSound(value: Float){
        if (offBool)
        {
            offDiff += 0.5
            if (offDiff == Off)
            {
                offDiff = 0
                offBool = false
                audioPlayer = AVAudioPlayer(contentsOfURL: url, error: nil)
                audioPlayer.play()
                AudioServicesPlayAlertSound(1023)
                ChangeColors()
        }
        }
        
        else if (Interval > 0)
        {
            if (value % Interval == 0)
            {
            audioPlayer = AVAudioPlayer(contentsOfURL: url, error: nil)
            audioPlayer.play()
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
            TimeOff.textColor = UIColor.blackColor()
            TimeOn.textColor = UIColor.whiteColor()
        self.view.backgroundColor = MyRed
        Micros.textColor = UIColor.blackColor()
        Seconds.textColor = UIColor.blackColor()
        Minutes.textColor = UIColor.blackColor()
        IntervalValue.tintColor = UIColor.blackColor()
        OffValue.tintColor = UIColor.blackColor()
       
   
        }
        else {
            TimeOff.textColor = UIColor.whiteColor()
            TimeOn.textColor = MyRed
            self.view.backgroundColor = UIColor.blackColor()
            Micros.textColor = MyRed
            Seconds.textColor = MyRed
            Minutes.textColor = MyRed
            
            IntervalValue.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
            OffValue.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)

        }
    }
}










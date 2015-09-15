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
    
    @IBOutlet weak var PlayButton: UIBarButtonItem!
    @IBOutlet weak var PauseButton: UIBarButtonItem!
    
    @IBOutlet weak var ResetButton: UIButton!
    @IBOutlet weak var TimeOff: UILabel!
    
    var Timer:NSTimer = NSTimer()
    var started = false
    var offBool = false
    var offDiff = 0
    var Off = 0
    var MicroCounter = 0
    var SecondCounter = 0
    var MinuteCounter = 0
    var Interval = 0
    var MyRed = UIColor(red: 192/255, green: 29/255, blue: 27/255, alpha: 1.0)

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
    }
    
    @IBAction func Start(sender: AnyObject) {
        if (!started){
            TimeOn.textColor = MyRed
        Timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("UpdateTimer"), userInfo: nil, repeats: true)
        started = true
        }
    }

    @IBAction func Stop(sender: AnyObject) {
        Timer.invalidate()
        started = false
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

            Minutes.text=String(format: "%02d",++MinuteCounter)
            IntervalSound(MinuteCounter)
            }
        }
        
    }
    
    @IBAction func StepperChange(sender: UIStepper) {
        var sentVal = Int(sender.value)
        IntervalLabel.text = sentVal.description
        Interval = sentVal
    }
    
    @IBAction func OffChange(sender: UIStepper) {
        var sent = Int(sender.value)
        OffLabel.text = sent.description
        Off = sent
    }
    
    func IntervalSound(value: Int){
        if (offBool)
        {
            
            if (++offDiff == Off)
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
        PlayButton.tintColor = UIColor.blackColor()
        PauseButton.tintColor = UIColor.blackColor()
        IntervalValue.tintColor = UIColor.blackColor()
        OffValue.tintColor = UIColor.blackColor()
        ResetButton.tintColor = UIColor.blackColor()
   
        }
        else {
            TimeOff.textColor = UIColor.whiteColor()
            TimeOn.textColor = MyRed
            self.view.backgroundColor = UIColor.blackColor()
            Micros.textColor = MyRed
            Seconds.textColor = MyRed
            Minutes.textColor = MyRed
            PlayButton.tintColor = MyRed
            PauseButton.tintColor = MyRed
            IntervalValue.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
            OffValue.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
            ResetButton.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)


        }
    }
}










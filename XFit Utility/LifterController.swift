//
//  LifterController.swift
//  XFit Utility
//
//  Created by Sam Hopkins on 8/25/15.
//  Copyright (c) 2015 Sam Hopkins. All rights reserved.
//

import UIKit

class LifterController: UIViewController {

    let defaults = NSUserDefaults.standardUserDefaults()
    var Lifts : [String] = ["Clean","Squat","Deadlift","Bench"]
    var liftIndex = 0
    var pounds = 1.0
    var isGraphViewShowing = false
    override func viewDidLoad() {
        
        LiftName.text = Lifts[liftIndex]
        LiftName.userInteractionEnabled = true
        if let currentLiftIndex = defaults.objectForKey("currentLift") as? Int
        {
            liftIndex = currentLiftIndex
        }
        else{
            liftIndex = 0
            defaults.setInteger(liftIndex, forKey: "currentLift")
        }
        DisplayPercentages(pounds)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var lifterView: LifterView!
    @IBOutlet weak var LiftName: UITextField!
    @IBOutlet weak var MaxLift: UITextField!
    @IBOutlet weak var Max95: UILabel!
    @IBOutlet weak var Max85: UILabel!
    @IBOutlet weak var Max75: UILabel!
    @IBOutlet weak var Max70: UILabel!
    @IBOutlet weak var Max60: UILabel!
    @IBOutlet weak var plottedLift: UILabel!
    @IBOutlet weak var maxPlottedLift: UILabel!
    
    @IBAction func LiftSwipeRight(sender: UISwipeGestureRecognizer) {
        var liftsSize = Lifts.count
        if (liftIndex < liftsSize - 1)
        {
            liftIndex++
            defaults.setObject(liftIndex, forKey: "currentLift")
            LiftName.text = Lifts[liftIndex]
        }
        else{
            liftIndex = 0
            defaults.setObject(liftIndex, forKey: "currentLift")
            LiftName.text = Lifts[liftIndex]
        }
        DisplayPercentages(pounds)
    }
    
    @IBAction func LiftSwipeLeft(sender: UISwipeGestureRecognizer) {
        var liftsSize = Lifts.count
        if (liftIndex > 0)
        {
            liftIndex--
            defaults.setInteger(liftIndex, forKey: "currentLift")
            LiftName.text = Lifts[liftIndex]
        }
        else{
            liftIndex = liftsSize - 1
            defaults.setInteger(liftIndex, forKey: "currentLift")
            LiftName.text = Lifts[liftIndex]
        }
        DisplayPercentages(pounds)

    }
    
    @IBAction func NewMax(sender: UIButton) {
        var weight = NSNumberFormatter().numberFromString(MaxLift.text)!.doubleValue
        var currentLift = Lifts[liftIndex]
        println(currentLift)
        var maxArray = defaults.objectForKey(currentLift) as? [Double] ?? [Double]()
        if (maxArray.count > 0){
            var prevMax = maxArray[maxArray.count - 1]
            if (weight > prevMax){
            
                maxArray.append(weight)
            }
        }
        else{
            maxArray.append(weight)
            }
        defaults.setObject(maxArray, forKey: currentLift)
        DisplayPercentages(pounds)
        }
    
    
    func DisplayPercentages(scaler :Double){
        var lift = Lifts[liftIndex]
        println(lift)
        LiftName.text = lift
        if let maxWeights = defaults.arrayForKey(lift) as? [Double]
        {
            if (maxWeights.count > 0){
            println(maxWeights)
            var maxWeight = maxWeights[maxWeights.count - 1]
            MaxLift.text = String(format: "%.2f", maxWeight*1.0*scaler)
            Max95.text = String(format: "%.2f", maxWeight*0.95*scaler)
            Max85.text = String(format: "%.2f", maxWeight*0.85*scaler)

            Max75.text = String(format: "%.2f", maxWeight*0.75*scaler)

            Max70.text = String(format: "%.2f", maxWeight*0.70*scaler)

            Max60.text = String(format: "%.2f", maxWeight*0.60*scaler)
            }
            else{
                
                MaxLift.text = String(format: "%.2f", 0.00)
                Max95.text = String(format: "%.2f", 0.00)
                Max85.text = String(format: "%.2f", 0.00)
                
                Max75.text = String(format: "%.2f", 0.00)
                
                Max70.text = String(format: "%.2f", 0.00)
                
                Max60.text = String(format: "%.2f", 0.00)
            }

        }
        else
        {
            MaxLift.text = String(format: "%.2f", 0.00)
            Max95.text = String(format: "%.2f", 0.00)
            Max85.text = String(format: "%.2f", 0.00)
            
            Max75.text = String(format: "%.2f", 0.00)
            
            Max70.text = String(format: "%.2f", 0.00)
            
            Max60.text = String(format: "%.2f", 0.00)
        }

        
    }
    
    @IBOutlet weak var unitsSegmentedControl: UISegmentedControl!
    @IBAction func ChooseUnits(sender: UISegmentedControl) {
        switch unitsSegmentedControl.selectedSegmentIndex
        {
        case 0:
            pounds = 1.0
            DisplayPercentages(pounds)
        case 1:
            pounds = 0.453592
            DisplayPercentages(pounds)
        default:
            break
        }
    }
    
    @IBAction func NewLiftButton(sender: UIButton) {
        var newLift = LiftName.text
        if !(contains(Lifts,newLift)){
        Lifts.append(LiftName.text)
        liftIndex = Lifts.count - 1
        DisplayPercentages(pounds)
        println(Lifts)
        }

    }
    
    @IBAction func RemoveLiftButton(sender: UIButton) {
        if (Lifts.count > 0){
        defaults.removeObjectForKey(Lifts[liftIndex])
        Lifts.removeAtIndex(liftIndex)
        liftIndex = 0
        DisplayPercentages(pounds)
        }
    }
    
    @IBAction func UndoNewMax(sender: UIButton) {
        var lift = Lifts[liftIndex]
        println(lift)
        LiftName.text = lift
        if let maxWeights = defaults.arrayForKey(lift) as? [Double]
        {
            var maxWeightsCopy = maxWeights
            maxWeightsCopy.removeAtIndex(maxWeightsCopy.count - 1)
            defaults.setObject(maxWeightsCopy, forKey: lift)
            DisplayPercentages(pounds)
        }

    }
    
    @IBAction func lifterViewTapGesture(gesture:UITapGestureRecognizer?) {
        if (isGraphViewShowing) {
            
            //hide Graph
            UIView.transitionFromView(graphView,
                toView: lifterView,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromLeft
                    | UIViewAnimationOptions.ShowHideTransitionViews,
                completion:nil)
        } else {
            
            //show Graph
            setupGraphDisplay()
            UIView.transitionFromView(lifterView,
                toView: graphView,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromRight
                    | UIViewAnimationOptions.ShowHideTransitionViews,
                completion: nil)
        }
        isGraphViewShowing = !isGraphViewShowing
    }
    
    func scalerMultiplier(scaler: Double)(currentVal: Double) -> Double {
        return Double(currentVal) * scaler
    }
    
    func setupGraphDisplay() {
        var lift = Lifts[liftIndex]
        println(lift)
        LiftName.text = lift
        if let maxWeights = defaults.arrayForKey(lift) as? [Double]
        {
        graphView.samplePoints = maxWeights.map(scalerMultiplier(pounds))
        graphView.setNeedsDisplay()
        maxPlottedLift.text = String(format: "%.2f", maxElement(graphView.samplePoints))
        plottedLift.text = "\(lift)"
            
        }

        
    }
    
}


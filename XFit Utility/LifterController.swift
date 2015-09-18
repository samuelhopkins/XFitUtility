//
//  LifterController.swift
//  XFit Utility
//
//  Created by Sam Hopkins on 8/25/15.
//  Copyright (c) 2015 Sam Hopkins. All rights reserved.
//

import UIKit

class LifterController: UIViewController, UITextFieldDelegate  {
    let defaults = NSUserDefaults.standardUserDefaults()
    var Lifts : [String] = ["Clean","Squat","Deadlift","Bench"]
    var liftIndex = 0
    var pounds = 1.0
    var isGraphViewShowing = false
    var labels :[UILabel] = []
    
    override func viewDidLoad() {
        self.LiftName.delegate = self;
        self.MaxLift.delegate = self
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        LiftName.resignFirstResponder()
        MaxLift.resignFirstResponder()
        if (isGraphViewShowing){
        let touch = touches.first as UITouch!
        let point = touch.locationInView(graphView)
        for i in 0..<graphView.pointsArray.count {
                let graphPoint = graphView.pointsArray[i]
            if (point.x > graphPoint.x - 10) && (point.x < graphPoint.x + 10){
                if !(labels.isEmpty){
                    for weightLabel in labels{
                        weightLabel.removeFromSuperview()
                    }
                }
                print(graphView.samplePoints[i])
                let label = UILabel(frame: CGRectMake(0, 0, 150, 21))
                label.center = CGPointMake(graphPoint.x + 20, graphPoint.y + 20)
                label.textAlignment = NSTextAlignment.Center
                label.textColor = UIColor.blackColor()
                label.font = UIFont(name: "Kailasa", size: 20)
                label.text = String(format: "%.2f", graphView.samplePoints[i] * pounds)
                graphView.addSubview(label)
                labels.append(label)
            }
            
            }
        }
    }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet var graphView: GraphView!
    @IBOutlet var lifterView: LifterView!
    @IBOutlet weak var LiftName: UITextField!
    @IBOutlet weak var MaxLift: UITextField!
    
    @IBAction func resignKeyBoard(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    @IBOutlet weak var Max95: UILabel!
    @IBOutlet weak var Max85: UILabel!
    @IBOutlet weak var Max75: UILabel!
    @IBOutlet weak var Max65: UILabel!
    @IBOutlet weak var Max55: UILabel!
        @IBOutlet weak var plottedLift: UILabel!
    @IBOutlet weak var maxPlottedLift: UILabel!
    
    @IBAction func LiftSwipeRight(sender: UISwipeGestureRecognizer) {
        let liftsSize = Lifts.count
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
        let liftsSize = Lifts.count
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
        self.view.endEditing(true)
        let weight = NSNumberFormatter().numberFromString(MaxLift.text!)!.doubleValue
        let currentLift = Lifts[liftIndex]
        print(currentLift)
        var maxArray = defaults.objectForKey(currentLift) as? [Double] ?? [Double]()
        if (maxArray.count > 0){
            let prevMax = maxArray[maxArray.count - 1]
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
        let lift = Lifts[liftIndex]
        print(lift)
        LiftName.text = lift
        if let maxWeights = defaults.arrayForKey(lift) as? [Double]
        {
            if (maxWeights.count > 0){
            print("Before Max Weights")
            print(maxWeights)
            let maxWeight = maxWeights[maxWeights.count - 1]
            MaxLift.text = String(format: "%.2f", maxWeight*1.0*scaler)
            Max95.text = String(format: "%.2f", maxWeight*0.95*scaler)
            Max85.text = String(format: "%.2f", maxWeight*0.85*scaler)

            Max75.text = String(format: "%.2f", maxWeight*0.75*scaler)

            Max65.text = String(format: "%.2f", maxWeight*0.65*scaler)

            Max55.text = String(format: "%.2f", maxWeight*0.55*scaler)
            }
            else{
                
                MaxLift.text = String(format: "%.2f", 0.00)
                Max95.text = String(format: "%.2f", 0.00)
                Max85.text = String(format: "%.2f", 0.00)
                
                Max75.text = String(format: "%.2f", 0.00)
                
                Max65.text = String(format: "%.2f", 0.00)
                
                Max55.text = String(format: "%.2f", 0.00)
            }

        }
        else
        {
            MaxLift.text = String(format: "%.2f", 0.00)
            Max95.text = String(format: "%.2f", 0.00)
            Max85.text = String(format: "%.2f", 0.00)
            
            Max75.text = String(format: "%.2f", 0.00)
            
            Max65.text = String(format: "%.2f", 0.00)
            
            Max55.text = String(format: "%.2f", 0.00)
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
        let newLift = LiftName.text
        if !(Lifts.contains(newLift!)){
        Lifts.append(LiftName.text!)
        liftIndex = Lifts.count - 1
        DisplayPercentages(pounds)
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
        let lift = Lifts[liftIndex]
       
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
        print(isGraphViewShowing)
        if (isGraphViewShowing) {
                self.view.backgroundColor = UIColor.whiteColor()
                containerView.backgroundColor = UIColor.whiteColor()
                UIView.transitionFromView(graphView,
                toView: lifterView,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromBottom.union(UIViewAnimationOptions.ShowHideTransitionViews),
                completion:nil)
        } else {
            self.view.backgroundColor = UIColor.blackColor()
            containerView.backgroundColor = UIColor.blackColor()
            //show Graph
            setupGraphDisplay()
            UIView.transitionFromView(lifterView,
                toView: graphView,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromTop.union(UIViewAnimationOptions.ShowHideTransitionViews),
                completion: nil)
            print("transitioned to graph view")
        }
        isGraphViewShowing = !isGraphViewShowing
    }
    
    func scalerMultiplier(scaler: Double)(currentVal: Double) -> Double {
        return Double(currentVal) * scaler
    }
    
    func setupGraphDisplay() {
        if !(labels.isEmpty){
            for label in labels{
                label.removeFromSuperview()
            }
        }
        let lift = Lifts[liftIndex]
        LiftName.text = lift
        if let maxWeights = defaults.arrayForKey(lift) as? [Double]
        {
        graphView.samplePoints = maxWeights.map(scalerMultiplier(pounds))
        graphView.setNeedsDisplay()
        maxPlottedLift.text = String(format: "%.2f", graphView.samplePoints.maxElement()!)
        plottedLift.text = "\(lift)"
            
        }

        
    }
    
}


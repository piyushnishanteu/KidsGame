//
//  ViewController.swift
//  MultipleSelectionCollectionVIew
//
//  Created by Soumil Chugh on 22/05/17.
//  Copyright © 2017 Nagarro. All rights reserved.
//

import UIKit
import GameplayKit
class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var drawView: DrawView!
    @IBOutlet weak var timerView: CircularTimerView!
    @IBOutlet weak var maxAttemptsCount: UILabel!
    @IBOutlet weak var attemptsLeftCount: UILabel!
    var points = [CGPoint]()
    var levelDuration:TimeInterval = 10.0
    var timer:Timer!
    var dataSource:[Any] = []
    var levelSum = 10
    var selectedArray:[Any] = []
    var isDraw:Bool = false{
        didSet{
            if isDraw {
                drawView.points = self.points
                drawView.isDrawing = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan))
        collectionView.addGestureRecognizer(pan)
        collectionView.canCancelContentTouches = false
        collectionView.allowsMultipleSelection = true
        timerView.animateCircle(duration: levelDuration)
        timer = Timer.scheduledTimer(timeInterval: levelDuration, target: self, selector: #selector(gameOver), userInfo: nil, repeats: false)
//            Timer.init(timeInterval: levelDuration, target: self, selector: #selector(timeUp), userInfo: nil, repeats: false)
        for i in 0..<10{
            dataSource.append(i)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:Shuffle Array
    private func shuffleArray(){
        var arr = [Int]()
        for i in 0..<10{
            arr.append(i)
        }
        let shuffledarray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: arr)
        print(shuffledarray)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.titleLabel.text = String(describing: dataSource[indexPath.row])
        return cell
    }
    func handlePan(recogniser:UIPanGestureRecognizer){
        switch  recogniser.state {
        case .began:
            points.removeAll()
            if let selectedPaths = collectionView.indexPathsForSelectedItems{
                for path in selectedPaths{
                    collectionView.deselectItem(at: path, animated: false)
                }
            }
            let location = recogniser.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: location){
                let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
//                cell.isSelected = !cell.isSelected
                if !cell.isSelected{
                    selectedArray.append(dataSource[indexPath.row])
                }
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                let point = CGPoint(x: cell.frame.midX, y: cell.frame.midY)
                self.points.append(point)
            }
        case .changed:
            let location = recogniser.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: location){
                let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
//                cell.isSelected = !cell.isSelected
                if !cell.isSelected{
                    selectedArray.append(dataSource[indexPath.row])
                }
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                let point = CGPoint(x: cell.frame.midX, y: cell.frame.midY)
                self.points.append(point)
            }
        case .ended:
            isDraw = true
            let selectedPaths = collectionView.indexPathsForSelectedItems
            print("selectedItems:",selectedPaths!.count)
            var resultantSum = 0
            for value in selectedArray{
                if let intValue = value as? Int{
                    resultantSum += intValue
                }
            }
            
            if resultantSum == levelSum{
                
                let alertController = UIAlertController.init(title: "You Won", message: "Next Level", preferredStyle: .alert)
                let okAction = UIAlertAction.init(title: "Ok", style: .default) { (action) in
                    self.timer = Timer.scheduledTimer(timeInterval: self.levelDuration, target: self, selector: #selector(self.gameOver), userInfo: nil, repeats: false)
                    self.timerView.animateCircle(duration: self.levelDuration)
                    self.collectionView.reloadData()
                    self.selectedArray.removeAll()
                    self.resetContext()
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true) {
                    self.timer.invalidate()
                }
            }else{
                animateOnInvalid()
                attemptsLeftCount.text = "\(Int(attemptsLeftCount.text!)! - 1)"
                if attemptsLeftCount.text == "0"{
                    self.gameOver()
                }
                self.collectionView.reloadData()
                self.selectedArray.removeAll()
            }
        default:
            break
        }
    }
 
    
    func gameOver(){
        let alertController = UIAlertController.init(title: "Game Over", message: "Try Again", preferredStyle: .alert)
        self.resetContext()
        let okAction = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            
            self.timer = Timer.scheduledTimer(timeInterval: self.levelDuration, target: self, selector: #selector(self.gameOver), userInfo: nil, repeats: false)
            self.timerView.animateCircle(duration: self.levelDuration)
            self.selectedArray.removeAll()
            self.collectionView.reloadData()
            self.attemptsLeftCount.text = self.maxAttemptsCount.text
            

        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true) { 
            self.timer.invalidate()
            
        }
    }
    //MARK:REset Context
    private func resetContext(){
    self.shuffleArray()//Shuffle Array
    //Clear the storedPoints array and reload collection view
    self.points.removeAll()
    self.isDraw = true
    self.collectionView.reloadData()
    }
    //MARK: Invalid Input Animation
    fileprivate func animateOnInvalid()
    {
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.collectionView.frame.midX - 8, y: self.collectionView.frame.midY))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.collectionView.frame.midX + 8, y: self.collectionView.frame.midY))
        animation.repeatCount = 5
        animation.autoreverses = true
        self.collectionView.layer.add(animation, forKey: "position")
        CATransaction.commit()
    }
    //MARK:Intesect of two Line
    func getIntersectionOfLines(line1: (a: CGPoint, b: CGPoint), line2: (a: CGPoint, b: CGPoint)) -> Bool {
        let distance = (line1.b.x - line1.a.x) * (line2.b.y - line2.a.y) - (line1.b.y - line1.a.y) * (line2.b.x - line2.a.x)
        if distance == 0 {
            print("error, parallel lines")
            //return CGPoint.zero
            return false
        }
        
        let u = ((line2.a.x - line1.a.x) * (line2.b.y - line2.a.y) - (line2.a.y - line1.a.y) * (line2.b.x - line2.a.x)) / distance
        let v = ((line2.a.x - line1.a.x) * (line1.b.y - line1.a.y) - (line2.a.y - line1.a.y) * (line1.b.x - line1.a.x)) / distance
        
        if (u < 0.0 || u > 1.0) {
            //print("error, intersection not inside line1")
           // return CGPoint.zero
            return false
        }
        if (v < 0.0 || v > 1.0) {
            //print("error, intersection not inside line2")
            //return CGPoint.zero
            return false
        }
        if line2.a == line1.b{
            return false
        }
        
        
        return true
        
        //return CGPoint(x:line1.a.x + u * (line1.b.x - line1.a.x),y: line1.a.y + u * (line1.b.y - line1.a.y))
    }
}


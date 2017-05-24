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
    
    var points = [CGPoint]()
    var levelDuration:TimeInterval = 10.0
    var timer:Timer!
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
        timer = Timer.scheduledTimer(timeInterval: levelDuration, target: self, selector: #selector(timeUp), userInfo: nil, repeats: false)
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
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                let point = CGPoint(x: cell.frame.midX, y: cell.frame.midY)
                self.points.append(point)
            }
        case .ended:
            isDraw = true
            let selectedPaths = collectionView.indexPathsForSelectedItems
            print("selectedItems:",selectedPaths!.count)
        default:
            break
        }
    }
 
    
    func timeUp(){
        let alertController = UIAlertController.init(title: "Game Over", message: "Try Again", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            self.timer = Timer.scheduledTimer(timeInterval: self.levelDuration, target: self, selector: #selector(self.timeUp), userInfo: nil, repeats: false)
            self.timerView.animateCircle(duration: self.levelDuration)
            self.shuffleArray()//Shuffle Array
            //Clear the storedPoints array and reload collection view
            self.points.removeAll()
            self.isDraw = true
            self.collectionView.reloadData()
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true) { 
            self.timer.invalidate()
        }
    }
}


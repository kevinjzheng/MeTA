//
//  HomepageController.swift
//  MeTA
//
//  Created by salman siraj on 2/20/20.
//  Copyright © 2020 senior design. All rights reserved.
//

import UIKit

class HomepageController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var trains: [Train] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trains = createArray()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    func createArray() -> [Train] {
        
        var tempTrains: [Train] = []
        
        let image1 = UIImage(named: "trainB")
        let image2 = UIImage(named: "trainC")
        
        let train1 = Train(image: image1!, title: "B Train 0.2 mi")
        let train2 = Train(image: image2!, title: "C Train 0.5 mi")
        
        
        tempTrains.append(train1)
        tempTrains.append(train2)
        
        return tempTrains
    }
}


extension HomepageController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trains.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let train = trains[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainCell") as! TrainCell
        
        cell.setTrain(train: train)
        
        return cell
    }
}

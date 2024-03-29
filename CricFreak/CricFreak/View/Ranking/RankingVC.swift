//
//  RankingVC.swift
//  CricFreak
//
//  Created by Admin on 24/2/23.
//

import UIKit
import SDWebImage

class RankingVC: UIViewController {
    
//MARK: - Variables
    var rankingViewModel = RankingViewModel()
    var data: RankingModel?
    var testData: [EasyRankingModel] = []
    var odiData: [EasyRankingModel] = []
    var t20Data: [EasyRankingModel] = []
    var tableData: [EasyRankingModel] = []
    var refreshControl = UIRefreshControl()

//MARK: - Outlets
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
//MARK: - Will Appear
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
//MARK: - Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NetworkManager.shared.monitorNetwork(viewController: self)
        
        refreshControl.addTarget(self, action: #selector(refreshTable), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        segmentControl.selectedSegmentIndex = 0
        
        activityIndicator.startAnimating()
        rankingViewModel.getRankingData()
        rankingViewModel.observable.binding() { [weak self] response in
            DispatchQueue.main.async {
                self?.data = response
                self?.separateRankingData()
                self?.selectSegment(id: self?.segmentControl.selectedSegmentIndex ?? 0)
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
            }
        }
    }
    
    
//MARK: - Action Buttons
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
        selectSegment(id: sender.selectedSegmentIndex)
    }
    
    
//MARK: - All Functions
    func selectSegment(id: Int) {
        tableData.removeAll()
        if(id == 0) {
            tableData = testData
        }
        else if(id == 1) {
            tableData = odiData
        }
        else {
            tableData = t20Data
        }
        tableView.reloadData()
    }
    
    func separateRankingData() {
        testData.removeAll()
        odiData.removeAll()
        t20Data.removeAll()
        for dataItem in (data?.data ?? []) {
            if(dataItem.gender == "men") {
                for team in (dataItem.team ?? []) {
                    var item = EasyRankingModel()
                    item.name = team.name ?? ""
                    item.image_path = team.imagePath ?? ""
                    item.ratings = team.ranking?.rating ?? 0

                    if(dataItem.type == "TEST") {
                        testData.append(item)
                    }
                    else if(dataItem.type == "ODI") {
                        odiData.append(item)
                    }
                    else if(dataItem.type == "T20I") {
                        t20Data.append(item)
                    }
                }
            }
        }
    }
    
    @objc func refreshTable() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
            self?.rankingViewModel.getRankingData()
            self?.refreshControl.endRefreshing()
        }
    }
}


//MARK: - Table Extensions
extension RankingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.rankingCell, for: indexPath) as! RankingTVC
        
        cell.bgView.layer.cornerRadius = 10
        
        cell.countryName.text = tableData[indexPath.row].name
        
        var flag = ""
        if(tableData[indexPath.row].name == "Ireland") {
            flag = CountryFlags.shared.countryFlagImg["Republic of Ireland"] ?? ""
        }
        else if(tableData[indexPath.row].name == "United States of America") {
            flag = CountryFlags.shared.countryFlagImg["USA"] ?? ""
        }
        else {
            flag = CountryFlags.shared.countryFlagImg[tableData[indexPath.row].name] ?? ""
        }
        
        cell.flag.sd_setImage(with: URL(string: flag))
        cell.ratings.text = "Ratings: " + String(tableData[indexPath.row].ratings)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "All Country"
    }
}

//
//  DetailsVC.swift
//  CricFreak
//
//  Created by Admin on 17/2/23.
//

import UIKit
import SDWebImage

class DetailsVC: UIViewController {
    
//MARK: - Variables
    var fixtureId: Int!
    var data: RecentTableData!
    
//MARK: - Outlets
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var teamAimg: UIImageView!
    @IBOutlet weak var teamBimg: UIImageView!
    @IBOutlet weak var topConstraints: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var teamA: UILabel!
    @IBOutlet weak var runA: UILabel!
    @IBOutlet weak var teamB: UILabel!
    @IBOutlet weak var runB: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var InfoContainer: UIView!
    @IBOutlet weak var ScoreboardContainer: UIView!
    @IBOutlet weak var SquadContainer: UIView!
    @IBOutlet weak var NetworkContainer: UIView!
    
    
//MARK: - Will Appear
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
//MARK: - Will Disappear
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
//MARK: - Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.monitorNetwork(viewController: self)
        
        DetailsViewModel.shared.observable.result = data
        
        setTopViewValues()
        designTopView()
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        selectContainer(segmentIndex: 0)
    }
    
//MARK: - Action Buttons
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        selectContainer(segmentIndex: sender.selectedSegmentIndex)
    }
    
//MARK: - All Functions
    func selectContainer(segmentIndex: Int) {
        InfoContainer.isHidden = true
        ScoreboardContainer.isHidden = true
        SquadContainer.isHidden = true
        NetworkContainer.isHidden = true
        
        if segmentIndex == -1 {
            NetworkContainer.isHidden = false
        }
        else if segmentIndex == 0 {
            InfoContainer.isHidden = false
        }
        else if segmentIndex == 1 {
            ScoreboardContainer.isHidden = false
        }
        else if segmentIndex == 2 {
            SquadContainer.isHidden = false
        }
    }
    
    func designTopView() {
        topView.layer.cornerRadius = 20
        topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        topView.clipsToBounds = true
        topConstraints.constant = topView.bounds.height/3.5
        bgView.layer.cornerRadius = 20
    }
    
    func setTopViewValues() {
        labelOne.text = data?.stage ?? ""
        teamA.text = data?.localteamName ?? ""
        teamB.text = data?.visitorteamName
        runA.text = (data?.localteamRun ?? "") + (data?.localteamWicket ?? "") + "(" + (data?.localteamOver ?? "") + ")"
        runB.text = (data?.visitorteamRun ?? "") + (data?.visitorteamWicket ?? "") + "(" + (data?.visitorteamOver ?? "") + ")"
        labelTwo.text = data?.note ?? ""
    }
}

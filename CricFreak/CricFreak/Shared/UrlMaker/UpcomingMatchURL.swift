//
//  UpcomingMatchURL.swift
//  CricFreak
//
//  Created by Admin on 15/2/23.
//

import Foundation

struct UpcomingMatchURL {
    static func getURL() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let date1 = Date()
        
        let calender = Calendar.current
        
        let date2 = calender.date(byAdding: .month, value: 2, to: date1)
        
        let from = dateFormatter.string(from: date1)
        let to = dateFormatter.string(from: date2!)
        
        
        return "https://cricket.sportmonks.com/api/v2.0/fixtures?fields[fixtures]=league_id,round,note,starting_at,status&include=stage,venue,localteam,visitorteam,runs&sort=starting_at&fields[stages]=name&fields[teams]=name,code,image_path&api_token=" + Constants.apiKey + "&filter[starts_between]=\(from)"+","+"\(to)"
    }
}

//
//  Movie.swift
//  movietime
//
//  Created by Adilet on 6/2/20.
//  Copyright © 2020 Adilet. All rights reserved.
//

import Foundation

struct Movie {
    var id: Int?
    var title: String?
    var posterPath: String?
    var backdropPath: String?
    var rating: Double?
    var duration: Int?
    var genres: [String]?
    var releaseDate: String?
    var budget: Int?
    var revenue: Int?
    var description: String?
    
    func getReleaseDate() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"

        if let relDate = releaseDate {
            if let date = dateFormatterGet.date(from: relDate) {
                return dateFormatterPrint.string(from: date)
            }
        }
        
        return releaseDate!
    }
    
    func getGenresList() -> String {
        var list = ""
        
        if let glist = genres {
            for g in glist {
                list += g + "  "
            }
        }
        
        return list
    }
    
    var durationString: String {
        var dur = ""
        
        if let minutes = duration {
            let hours = minutes / 60
            let mins = minutes % 60
            
            dur = "\(hours) hours \(mins) min"
        }
        
        return dur
    }
    
    func getMoney() -> [String] {
        var br = [String]()
        
        if let b = budget, let r = revenue {
            
            let numberFormatter = NumberFormatter()
            numberFormatter.groupingSeparator = ","
            numberFormatter.groupingSize = 3
            numberFormatter.usesGroupingSeparator = true
            numberFormatter.decimalSeparator = "."
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 2
            
            let b = numberFormatter.string(from: NSNumber(value: b))!
            let r = numberFormatter.string(from: NSNumber(value: r))!
            br.append("$ \(b)")
            br.append("$ \(r)")
        }
        
        return br
    }
    
    
}

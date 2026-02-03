//
//  AppConfiguration.swift
//  Navigation
//
//  Created by Лисин Никита on 02.02.2026.
//

import Foundation

enum AppConfiguration {
    case people(String)
    case starships(String)
    case planets(String)
    
    static var random: AppConfiguration {
        let randomCase = Int.random(in: 0...2)
        let urls = [
            "https://swapi.dev/api/people/8",
            "https://swapi.dev/api/starships/3",
            "https://swapi.dev/api/planets/5"
        ]
        
        switch randomCase {
        case 0:
            return .people(urls[0])
        case 1:
            return .starships(urls[1])
        case 2:
            return .planets(urls[2])
        default:
            return .people(urls[0])
        }
    }
    
    var description: String {
        switch self {
        case .people(let url):
            return "Люди (\(url))"
        case .starships(let url):
            return "Звездолеты (\(url))"
        case .planets(let url):
            return "Планеты (\(url))"
        }
    }
}

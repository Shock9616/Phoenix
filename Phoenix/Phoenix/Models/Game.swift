//
//  Game.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2022-12-24.
//

import Foundation

struct Game: Codable, Comparable, Hashable, Sendable {
    var id: UUID = UUID()
    var steamID: String = ""
    var igdbID: String = ""
    var gameFile: String = ""
    var launcher: String = ""
    var metadata: [String: String] = [
        "rating": "",
        "release_date": "",
        "last_played": "",
        "developer": "",
        "header_img": "",
        "cover": "",
        "description": "",
        "genre": "",
        "publisher": "",
    ]
    var screenshots: [String?] = []
    var icon: String = ""
    var name: String = ""
    var platformName: String = "Other"
    var status: Status = Status.none
    var recency: Recency = Recency.never
    var isHidden: Bool = false
    var isFavorite: Bool = false
    
    /**
     Compares two `Game` objects based on their `name` property.
     
     - Parameters:
     - lhs: The left-hand side of the comparison.
     - rhs: The right-hand side of the comparison.
     
     - Returns: `true` if the `name` property of the left-hand side is
     lexicographically less than the `name` property of the
     right-hand side, `false` otherwise.
     */
    static func < (lhs: Game, rhs: Game) -> Bool {
        return lhs.name.compareSpecial(rhs.name) == .orderedAscending
    }
}

extension String {
    func compareSpecial(_ other: String) -> ComparisonResult {
        let lhsCharacters = Array(self.lowercased())
        let rhsCharacters = Array(other.lowercased())

        for (lhsChar, rhsChar) in zip(lhsCharacters, rhsCharacters) {
            if lhsChar.isNumber && rhsChar.isLetter {
                return .orderedDescending
            } else if lhsChar.isLetter && rhsChar.isNumber {
                return .orderedAscending
            } else if lhsChar != rhsChar {
                return lhsChar < rhsChar ? .orderedAscending : .orderedDescending
            }
        }

        return self.count < other.count ? .orderedAscending : (self.count > other.count ? .orderedDescending : .orderedSame)
    }
}

struct GamesList: Codable {
    var games: [Game]
}


//
//  DataStructs.swift
//  tpnote
//
//  Created by user226973 on 2/13/23.
//

import Foundation

// MARK: - Token
struct Token: Codable {
    let accessToken, tokenType: String
    let expiresIn: Int
    let sub: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case sub
    }
}
// MARK: - Categories
struct Categories: Codable {
    let links: Links
    let categories, rootCategories, guildCategories: [Category]

    enum CodingKeys: String, CodingKey {
        case links = "_links"
        case categories
        case rootCategories = "root_categories"
        case guildCategories = "guild_categories"
    }
}

// MARK: - SelfClass
struct SelfClass: Codable {
    let href: String
}

// MARK: - Category
struct Category: Codable {
    let key: SelfClass
    let name: String
    let id: Int
}

// MARK: - Links
struct Links: Codable {
    let linksSelf: SelfClass

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

struct Achievements: Codable {
    let links: Links
    let id: Int
    let name: String
    let achievements: [Achievement]
    let parentCategory: Achievement
    let isGuildCategory: Bool
    let aggregatesByFaction: AggregatesByFaction
    let displayOrder: Int

    enum CodingKeys: String, CodingKey {
        case links = "_links"
        case id, name, achievements
        case parentCategory = "parent_category"
        case isGuildCategory = "is_guild_category"
        case aggregatesByFaction = "aggregates_by_faction"
        case displayOrder = "display_order"
    }
}

// MARK: - ParentCategory
struct Achievement: Codable {
    let key: SelfClass
    let name: String
    let id: Int
}

// MARK: - AggregatesByFaction
struct AggregatesByFaction: Codable {
    let alliance, horde: Alliance
}

// MARK: - Alliance
struct Alliance: Codable {
    let quantity, points: Int
}

struct AchievementDetail: Codable {
    let links: Links
    let id: Int
    let category: Category
    let name, description: String
    let points: Int
    let isAccountWide: Bool
    let criteria: Criteria
    let media: Media
    let displayOrder: Int

    enum CodingKeys: String, CodingKey {
        case links = "_links"
        case id, category, name, description, points
        case isAccountWide = "is_account_wide"
        case criteria, media
        case displayOrder = "display_order"
    }
}

// MARK: - Criteria
struct Criteria: Codable {
    let id: Int
    let description: String
    let amount: Int
}



// MARK: - Media
struct Media: Codable {
    let key: SelfClass
    let id: Int
}



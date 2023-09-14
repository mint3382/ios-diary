//
//  Weather.swift
//  Diary
//
//  Created by MINT, BMO on 2023/09/14.
//

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

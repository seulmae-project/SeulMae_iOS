//
//  MockData.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

// var fstvls: ODPResponseDTO<[FestivalDTO]> = load("fstvlData.json") // [Festival]

func load<T: ModelType>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = T.decoder
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

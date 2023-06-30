//
//  FilmManager.swift
//  FilmsList
//
//  Created by Gleb on 29.06.2023.
//

import Foundation

class FilmManager {
    
    var myFilms: [films] = []
    
    var filmsByYear: [[films]] {
        
        let sortedFilms = myFilms.sorted { $0.year ?? 0 < $1.year ?? 0 }
        let groupedFilms = Dictionary(grouping: sortedFilms, by: { $0.year })
        let sortedSections = groupedFilms.sorted { $0.key! < $1.key! }
        return sortedSections.map { $0.value }
    }
    
    func fetchFilmsFromWeb(completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "https://s3-eu-west-1.amazonaws.com/sequeniatesttask/films.json") else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "No data received", code: 0, userInfo: nil)
                completion(error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                if let jsonDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    // JSON data is a dictionary
                    if let filmsArray = jsonDictionary["films"] as? [[String: Any]] {
                        // Extract the films array from the dictionary
                        let films = try decoder.decode([films].self, from: JSONSerialization.data(withJSONObject: filmsArray))
                        self?.myFilms = films
                    }
                } else {
                    // JSON data is an array
                    let films = try decoder.decode([films].self, from: data)
                    self?.myFilms = films
                }
                
                print(self!.myFilms)
                completion(nil)
            } catch {
                completion(error)
            }
        }
        
        task.resume()
    }
}

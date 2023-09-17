//
//  DiaryService.swift
//  Diary
//
//  Created by MINT, BMO on 2023/09/13.
//

import UIKit
import CoreData

struct DiaryService: CoreDataManageable {
    var container: NSPersistentContainer
    
    init(name: String) {
        self.container = {
            let container = NSPersistentContainer(name: name)
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()
    }
    
    func loadDiaryList() throws -> [DiaryEntity] {
        try self.fetch(of: DiaryEntity())
    }
    
    func createDiary() -> DiaryEntity {
        let diary = DiaryEntity(context: container.viewContext)
        
        diary.id = UUID()
        diary.date = Date()
        
        return diary
    }
    
    func write(content: String, to diary: DiaryEntity) {
        let separatedContent = separateTitleAndBody(of: content)
        
        diary.title = separatedContent.title
        diary.body = separatedContent.body
    }
    
    func delete(_ diary: DiaryEntity) {        
        self.deleteContext(of: diary)
    }
    
    func saveDiary() throws {
        try self.saveContext()
    }
    
    private func separateTitleAndBody(of content: String) -> (title: String, body: String) {
        let title = content.components(separatedBy: "\n")[0]
        var body = ""
        
        if let range = content.range(of: "\n") {
            body = String(content[range.upperBound...])
        }
        
        return (title, body)
    }
}

extension DiaryService: DataTaskManageable {
    func fetchCurrentWeather(
        location: (lat: String, lon: String),
        completion: @escaping (Result<CurrentWeather, NetworkError>) -> Void
    ) {
        var component = URLComponents()
        component.scheme = OpenWeatherNameSpace.scheme
        component.host = OpenWeatherNameSpace.host
        component.path = OpenWeatherNameSpace.path
        
        let query = ["appid": Bundle.main.openWeatherApiKey, "lat": location.lat, "lon": location.lon]
        component.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = component.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        performRequest(request: request, objectType: CurrentWeather.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchWeatherIcon(iconId: String) -> UIImage {
        let url = URL(string: "https://openweathermap.org/img/wn/\(iconId)@2x.png")
        let data = try? Data(contentsOf: url!)
        
        return UIImage(data: data!)!
    }
}

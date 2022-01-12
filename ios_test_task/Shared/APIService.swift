//
//  ImageLoaderService.swift
//  ios_test_task
//
//  Created by Ilya Buldin on 12.01.2022.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PUT
}

protocol APIServiceProtocol {
    func configureParametersOfURL(with searchTerm: String?) -> [String: String]
    func configureURL(with parameters: [String: String], path: String) -> URL?
    func makeRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void)
    func makeSearchRequest(with searchTerm: String, completion: @escaping (Result<SearchResult, Error>) -> Void)
    func makeRandomPhotosRequest(completion: @escaping (Result<[Photo], Error>) -> Void)
    func makeAdditionalPhotoInfoRequest(by id: String, completion: @escaping (Result<AdditionalPhotoInfo, Error>) -> Void)
}

final class APIService: APIServiceProtocol {
    
    static let shared: APIServiceProtocol = APIService()
    
    struct Constants {
        static let accessKey = "7ihQSmGBndShpEoHZaAdnEATHijfLp2YLTwljqa4-fk"
        static let secretKey = "0xPXWnyzObeWq0t5S_wjLBjyOoZepaIAGPDS7AhP50k"
        
        static let urlScheme = "https"
        static let urlHost = "api.unsplash.com"
        static let searchURLPath = "/search/photos"
        static let randomPhotosPath = "/photos"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    
    func configureParametersOfURL(with searchTerm: String? = nil) -> [String: String] {
        let pageParameter = 1
        let perPageParameter = 50
        var parameters: [String: String] = [:]
        if let searchTerm = searchTerm {
            parameters["query"] = searchTerm
        }
        parameters["page"] = "\(pageParameter)"
        parameters["per_page"] = "\(perPageParameter)"
        return parameters
    }
    
    func configureURL(with parameters: [String: String], path: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.urlScheme
        urlComponents.host = Constants.urlHost
        urlComponents.path = path
        urlComponents.queryItems = parameters.map({ key, value in
            URLQueryItem(name: key, value: value)
        })
        return urlComponents.url
    }
    
    
    func makeRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        guard let url = url else {
            return
        }
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(Constants.accessKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = type.rawValue
        request.timeoutInterval = 30
        completion(request)
    }
    
    func makeSearchRequest(with searchTerm: String, completion: @escaping (Result<SearchResult, Error>) -> Void) {
        let preparedParameters = configureParametersOfURL(with: searchTerm)
        let url = configureURL(with: preparedParameters, path: Constants.searchURLPath)
        makeRequest(with: url, type: .GET) { request in
            print(url?.absoluteString ?? "None")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(SearchResult.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    func makeRandomPhotosRequest(completion: @escaping (Result<[Photo], Error>) -> Void) {
        let preparedParameters = configureParametersOfURL()
        let url = configureURL(with: preparedParameters, path: Constants.randomPhotosPath)
        makeRequest(with: url, type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode([Photo].self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    func makeAdditionalPhotoInfoRequest(by id: String, completion: @escaping (Result<AdditionalPhotoInfo, Error>) -> Void) {
        let preparedParameters: [String: String] = [:]
        let url = configureURL(with: preparedParameters, path: Constants.randomPhotosPath + "/\(id)")
        makeRequest(with: url, type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(AdditionalPhotoInfo.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
}

//
//  APICaller.swift
//  Netflix Clone
//
//  Created by eren on 6.03.2024.
//

import Foundation
import SystemConfiguration

struct Constants {
    static let API_KEY = "25f42d6d1a50b209c73e8982695e4bc8"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyBgF5z4dQ1RwosOm9G9MkQbot4Lp6_VqL8"
    static let YoutubeBaseUrl = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedTogetData
}

class APICaller {
    
    static let shared = APICaller()
    
    
    func getTrendingMovies(page: Int, completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)&page=\(page)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    func getTrendingTvs(page: Int, completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)&page=\(page)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
                        
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    func getUpcomingMovies(page: Int, completion: @escaping (Result<[Title] , Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?language=en-US&api_key=\(Constants.API_KEY)&page=\(page)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func getPopular(page: Int, completion: @escaping (Result<[Title] , Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?language=en-US&api_key=\(Constants.API_KEY)&page=\(page)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
                print(url)
            }
        }
        task.resume()
    }
    
    func getTopRated(page: Int, completion: @escaping (Result<[Title] , Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?language=en-US&api_key=\(Constants.API_KEY)&page=\(page)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title] , Error>) -> Void) {
        
        guard let url = URL(
            string: "\(Constants.baseURL)/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&api_key=\(Constants.API_KEY)"
        ) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Title] , Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement , Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        
        guard let url = URL(string: "\(Constants.YoutubeBaseUrl)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                // let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                // print(results)
                // print(url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
            } catch {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func getMovieCasts(with id: Int, completion: @escaping (Result<[Cast], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/\(id)/credits?api_key=\(Constants.API_KEY)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(CastResponse.self, from: data)
                completion(.success(results.cast))
            } catch {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}

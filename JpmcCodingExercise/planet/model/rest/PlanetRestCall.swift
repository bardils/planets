//
//  PlanetRestCall.swift
//  JpmcCodingExercise
//
//  Created by Sarah Rosie on 15/12/2018.
//  Copyright © 2018 Sarah Rosie. All rights reserved.
//

import Foundation

/// Used to execute a REST call to fetch the Planets from the server
class PlanetRestCall {
    
    /// Errors which can occur when making a PlanetRestCall
    ///
    /// - parsing: unable to parse the data from the server
    /// - server: error in response from the server
    /// - noData: no data received from the server
    enum PlanetRestCallError: Error {
        case parse(error: Error)
        case server(error: Error)
        case noData
    }
    
    /// Determines the result of the rest call execution
    ///
    /// - success: the call was successful
    /// - failure: the call failed with an error
    enum RestCallResult<T>{
        case success(T)
        case failure(Error)
    }
    
    // MARK: static
    
    private static let apiUrl = "https://swapi.co/api/planets/?format=json"
    
    // MARK: members
    
    private let planetListParser: PlanetListParser
    private let urlSession: URLSession
    private (set) var dataTask: URLSessionDataTask?
    private let url = URL(string: PlanetRestCall.apiUrl)!
    
    // MARK: init
    init(planetListParser: PlanetListParser, urlSession: URLSession = .shared) {
        self.planetListParser = planetListParser
        self.urlSession = urlSession
    }
    
    /// Asynchronously executes the rest call
    ///
    /// - Parameter completion: func called on completion containing a RestCallResult
    func execute(onCompletion completion:@escaping (_ result: RestCallResult<PlanetListResponse>)->Void) {
        
        dataTask?.cancel()
        
        dataTask = urlSession.dataTask(with: url){
            [weak self] data, urlResponse, error  in
            defer { self?.dataTask = nil }
            
            guard error == nil else {completion(.failure(PlanetRestCallError.server(error: error!))); return}
            do {
                if let planetListResponse = try self?.planetListParser.parse(data: data){
                    completion(.success(planetListResponse))
                }
            }
            catch {
                completion(.failure(PlanetRestCallError.parse(error: error)))
            }
        }
        dataTask?.resume()
    }

    // MARK: PlanetListParser
    
    /// Parses data received on execution of the Rest call
    class PlanetListParser{
        
        private let jsonDecoder: JSONDecoder
        init(jsonDecoder: JSONDecoder = JSONDecoder()){
            self.jsonDecoder = jsonDecoder
        }
        
        /// Parses the data, if possible, into a PlanetListResponse
        ///
        /// - Parameter data: data from the response of a PlanetRestcall
        /// - Returns: PlanetListResponse parsed from the data
        /// - Throws: Error if unable to decode the data or the data is nil
        func parse(data: Data?) throws ->PlanetListResponse{
            if let data = data{
                return try jsonDecoder.decode(PlanetListResponse.self, from: data)
            }
            throw PlanetRestCallError.noData
        }
    }
    
}

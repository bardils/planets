//
//  PlanetDownloader.swift
//  JpmcCodingExercise
//
//  Created by Sarah Rosie on 15/12/2018.
//  Copyright © 2018 Sarah Rosie. All rights reserved.
//
import Foundation

/// Downloads Planets from the API and stores them in the PlanetStore
class PlanetDownloader{
    
    /// The result of a download request
    ///
    /// - success: the download was successful
    /// - failure: the download failed with an Error
    enum DownloadResult{
        case success()
        case failure(Error)
    }
    
    private let planetRestCall: PlanetRestCall
    private let planetProcessor: PlanetListResponseProcessor
    
    init(planetRestCall: PlanetRestCall, planetProcessor: PlanetListResponseProcessor) {
        self.planetRestCall = planetRestCall
        self.planetProcessor = planetProcessor
    }
    
    /// Asynchonously fetches and stores Planets
    ///
    /// - Parameter completion: called when the download is complete
    func fetchAndStorePlanets(onCompletion completion:@escaping (_ result: DownloadResult)->Void) {
        planetRestCall.execute {
            [weak self] result in
            switch result{
            case .success(let planetListResponse):
                self?.processPlanetListReponse(planetListResponse: planetListResponse, onCompletion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func processPlanetListReponse(planetListResponse: PlanetListResponse, onCompletion completion:@escaping (_ result: DownloadResult)->Void){
        switch planetProcessor.process(planetListResponse: planetListResponse){
        case .success():
            completion(.success())
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

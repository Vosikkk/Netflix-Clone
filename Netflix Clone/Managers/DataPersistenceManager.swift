//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Саша Восколович on 03.10.2023.
//

import Foundation
import UIKit
import CoreData

enum DatabaseError: Error {
    case failedToSaveData
    case failedToFetchData
    case failedToDeleteData
    case duplicateItem
}


class DataPersistenceManager {
    
   
    static let shared = DataPersistenceManager()
    
    func downloadTitle(with model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<TitleItem>(entityName: "TitleItem")
            fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(model.id))
        
        do {
            let existingItems = try context.fetch(fetchRequest)
            if let _ = existingItems.first {
                completion(.failure(DatabaseError.duplicateItem))
                return
            }
            
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
            return
        }
        
        
        let item = TitleItem(context: context)
        item.id = Int64(model.id)
        item.media_type = model.media_type
        item.original_language = model.original_language
        item.original_name = model.original_name
        item.original_title = model.original_title
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
       
    }
    
    func fetchTitlesFromDataBase(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
           let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
        
    }
}

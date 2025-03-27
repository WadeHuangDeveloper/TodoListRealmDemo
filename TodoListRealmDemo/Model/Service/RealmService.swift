//
//  RealmService.swift
//  TodoListRealmDemo
//
//  Created by Huei-Der Huang on 2025/3/26.
//

import Foundation
import RealmSwift

class RealmService {
    static let shared = RealmService()
    
    private init() {}
    
    func read<T: Object>(primaryKey: UUID) throws -> T? {
        do {
            let realm = try Realm()
            let object = realm.object(ofType: T.self, forPrimaryKey: primaryKey)
            return object
        } catch {
            print("\(Self.self).\(#function) error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func readAll<T: Object>() throws -> [T] {
        do {
            let realm = try Realm()
            let objects = realm.objects(T.self)
            return Array(objects)
        } catch {
            print("\(Self.self).\(#function) error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func create<T: Object>(object: T) throws {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object, update: .modified)
            }
        } catch {
            print("\(Self.self).\(#function) error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func update<T: Object>(object: T) throws {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object, update: .modified)
            }
        } catch {
            print("\(Self.self).\(#function) error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func delete<T: Object>(type: T.Type, primaryKey: UUID) throws {
        do {
            let realm = try Realm()
            guard let task = realm.object(ofType: type, forPrimaryKey: primaryKey) else {
                throw NSError(domain: "\(Self.self)", code: 404, userInfo: [NSLocalizedDescriptionKey: "\(#function) failed"])
            }
            try realm.write {
                realm.delete(task)
            }
        } catch {
            print("\(Self.self).\(#function) error: \(error.localizedDescription)")
            throw error
        }
    }
}

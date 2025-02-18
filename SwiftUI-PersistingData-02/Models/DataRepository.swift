//
//  Repository.swift
//  SwiftUI-PersistingData-02
//
//  Created by Mike Panitz on 5/3/21.
//

import Foundation
import RealmSwift

class DataRepository: ObservableObject {
    
    init(realm: Realm) {
        // We're not actually doing anything with this
        // but it does show how to initialize a more
        // complicated object
    }
    
    func saveDog(newName: String, newAge: Int) {
        objectWillChange.send()
        let realm = try! Realm()

        try! realm.write {
            let theDog = Dog(id: UUID().hashValue, name: newName, age: newAge)
            realm.add(theDog)
        }
    }
    
    func loadDogs() -> Results<Dog> {
        let realm = try! Realm()
        return realm.objects(Dog.self)
    }
    
    func findADog(name: String) -> Dog? {
        let realm = try! Realm()
        let results = realm.objects(Dog.self).filter("name = " + name)
        if results.count != 1 {
            return nil
        } else {
            // return a 'normal' Dog object, not a Realm Results thingee
            // call the initializer / constructor on the 1 thing in the Results using map
            // remember that .map returns an array
            // so get element 0, the one and only thing in the array
            // then return that
            return results.map(Dog.init)[0]
        }
    }
    
    func deleteDog(theDog: Dog) {
        objectWillChange.send()

        do {
            // 3
            let realm = try Realm()
            let results = realm.objects(Dog.self).filter( "id = " + String(theDog.id) + "  ")
            
            if results.count != 1 {
                return
            }

            try realm.write {
                // 4
                realm.delete(results[0])
            }
        } catch let error {
          // Handle error
          print(error.localizedDescription)
        }
    }
    
    func deleteAllDogs() {
        objectWillChange.send()

        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch let error {
          // Handle error
          print(error.localizedDescription)
        }
    }
    
    func updateDog( id: Int, newName:String, newAge:Int) {
        // 1
        objectWillChange.send()
        do {
          // 2
          let realm = try Realm()
          try realm.write {
            // 3
            realm.create(
              Dog.self,
                value: ["id": id, "name": newName, "age": newAge],
              update: .modified)
          }
        } catch let error {
          // Handle error
          print(error.localizedDescription)
        }
    }
    
    func saveKangaroo(newName: String, newAge: Int) {
        objectWillChange.send()
        let realm = try! Realm()
        
        try! realm.write {
            let theKangaroo = Kangaroo(id: UUID().hashValue, name: newName, age: newAge)
            realm.add(theKangaroo)
        }
    }
    
    func loadKangaroo() -> Results<Kangaroo> {
        let realm = try! Realm()
        return realm.objects(Kangaroo.self)
    }
    
    func deleteKangaroo(theKangaroo: Kangaroo) {
        objectWillChange.send()

        do {
            // 3
            let realm = try Realm()
            let results = realm.objects(Kangaroo.self).filter( "id = " + String(theKangaroo.id) + "  ")
            
            if results.count != 1 {
                return
            }

            try realm.write {
                // 4
                realm.delete(results[0])
            }
        } catch let error {
          // Handle error
          print(error.localizedDescription)
        }
    }
    
    func updateKangaroo( id: Int, newName:String, newAge:Int) {
        objectWillChange.send()
        do {
            let realm = try Realm()
            try realm.write {
                realm.create(Kangaroo.self, value: ["id": id, "name": newName, "age":newAge], update: .modified)
            }
        }catch let error {
            print(error.localizedDescription)
        }
    }
}

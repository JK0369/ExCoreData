//
//  MyItemRepository.swift
//  ExCoredata
//
//  Created by 김종권 on 2022/10/24.
//

import CoreData

struct MyItemModel {
  var name: String
}

class MyItemRepository {
  let coreDataStorage: CoreDataStorage
  
  init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
    self.coreDataStorage = coreDataStorage
  }
  
  func add(name: String) {
    let context = coreDataStorage.taskContext()
    if let savedItem = fetch(name, in: context) {
      savedItem.updatedDate = Date()
    } else {
      create(name, in: context)
    }
    
    context.performAndWait {
      do {
        try context.save()
      } catch {
        print(error)
      }
    }
  }
  
  private func fetch(_ name: String, in context: NSManagedObjectContext) -> MyItem? {
    let fetchRequest = MyItem.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "name == %@", argumentArray: [name])
    do {
      return try context.fetch(fetchRequest).first
    } catch {
      print("fetch for update Person error: \(error)")
      return nil
    }
  }
  
  fileprivate func create(_ name: String, in context: NSManagedObjectContext) {
    let item = MyItem(context: context)
    item.name = name
    item.updatedDate = Date()
  }
  
  func getItems() -> [MyItemModel] {
    fetchAll()
      .compactMap(\.name)
      .map(MyItemModel.init)
  }
  
  private func fetchAll() -> [MyItem] {
    let request = MyItem.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \MyItem.updatedDate, ascending: false)]
    do {
      return try coreDataStorage.viewContext.fetch(request)
    } catch {
      print("fetch Person error: \(error)")
      return []
    }
  }
}

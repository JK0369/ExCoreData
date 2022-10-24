//
//  ContentView.swift
//  ExCoredata
//
//  Created by 김종권 on 2022/10/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \MyItem.updatedDate, ascending: false)])
  private var items: FetchedResults<MyItem>
  let repo = MyItemRepository()
  
  var body: some View {
    VStack {
      ForEach(items) { item in
        Text(item.name!)
      }
      Text("Hello, world!")
        .padding()
        .onAppear {
          print(items.count)
          print(repo.getItems().count)
          // 샘플 데이터 준비
          // repo.add(name: "jake")
          // repo.add(name: "kim")
        }
      Button("Add 'jake123'") {
        addItem("jake123")
      }
    }
  }
  
  private func addItem(_ name: String) {
    withAnimation {
      let newItem = MyItem(context: viewContext)
      newItem.updatedDate = Date()
      newItem.name = name
      do {
        try viewContext.save()
      } catch {
        print(error)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

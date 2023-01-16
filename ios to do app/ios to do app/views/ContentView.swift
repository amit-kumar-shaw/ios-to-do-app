//
//  ContentView.swift
//  ios to do app
//
//  Created by Cristi Conecini on 04.01.23.
//

import SwiftUI
import CoreData
import FirebaseAuth

struct ContentView: View {
    
    
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var projectName = ""
    @State private var projectColor = Color.white
    @State private var showModal = false

    var body: some View {
        NavigationView {
            ZStack{
                
                VStack(alignment: .leading,spacing: 0){
                    
                    Text("Welcome")
                        .font(.system(size: 32))
                        .padding(.leading,20)
                    
                    List{
                        HStack{
                            NavigationLink(destination: TodoList(), label: {
                                Image(systemName: "hourglass.circle.fill")
                                Text("Upcoming")
                            })
                        }
                        
                        HStack{
                            NavigationLink(destination: TodoList(), label: {
                                Image(systemName: "calendar.badge.exclamationmark")
                                Text("Today")
                            })
                        }
                        
                        HStack{
                            NavigationLink(destination: TodoList(), label: {
                                Image(systemName: "gearshape")
                                Text("Setting")
                            })
                        }
                        
                    }
                    .frame(height: 180)
                    
                    List {
                
                        ForEach(items) { item in
                            NavigationLink(destination: TodoList(), label: {
                               
                                //Text(item.timestamp!, formatter: itemFormatter)
                                
                                Text(item.projectName ?? "Project")
                            })
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                        }
                        ToolbarItem {
                           addButton
                        }
                    }
                }.padding(.zero)
            }
            
        }
    }
    
    private var addButton: some View {
        Button(action:{ self.showModal = true}) {
            Label("Add Item", systemImage: "plus")
        }.sheet(isPresented: $showModal) {
            VStack {
                Text("Add a new item")
                    .font(.title)
                
                TextField("Project Name", text: self.$projectName)
                ColorPicker("Project Color", selection: self.$projectColor)
                
                Button(action: {
                    // Create a new item with the project name and color entered by the user
                    let newItem = Item(context: self.viewContext)
                    newItem.projectName = self.projectName
                    //newItem.projectColor = self.projectColor
                    newItem.timestamp = Date()

                    do {
                        try self.viewContext.save()
                    } catch {
                       
                    }
                    self.showModal = false
                }) {
                    Text("Add")
                }
            }.padding(.all,50)
        }
    }



    
    private func addItem() {
        
        withAnimation {
            
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

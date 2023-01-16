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
    @State private var isAuthenticated: Bool = Auth.auth().currentUser?.tenantID != nil;
    
//    private var authListenerHandle: AuthStateDidChangeListenerHandle ;
    
    
//    init(){
//        self.authListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
//            isAuthenticated = user?.tenantID != nil
//
//            print("current user id \(String(describing: user?.tenantID))");
//        }
//    }

    var body: some View {
        Group{
            isAuthenticated ?
            AnyView(NavigationView{
                            List {
                                ForEach(items) { item in
                                    NavigationLink(destination: TodoList(), label: {
                                        Text(item.timestamp!, formatter: itemFormatter)
                                    })
                                }
                                .onDelete(perform: deleteItems)
                            }
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    EditButton()
                                }
                                ToolbarItem {
                                    Button(action: addItem) {
                                        Label("Add Item", systemImage: "plus")
                                    }
                                }
                            }
                            Text("Select an item")
            }) :
            AnyView(LoginScreen())
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

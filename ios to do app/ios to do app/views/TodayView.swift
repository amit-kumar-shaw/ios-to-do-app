//
//  TodayView.swift
//  ios to do app
//
//  Created by Cristi Conecini on 25.01.23.
//

import SwiftUI

struct TodayView: View {
    
    @ObservedObject var viewModel: TodayViewModel
    
    init(){
        self.viewModel = TodayViewModel()
    }
    
    var body: some View {
        VStack {
            List{
                
                Section{
                    header
                }
                
                Section(){
                    if viewModel.todoList.isEmpty {
                        emptyView()
                    }else {
                        ForEach($viewModel.todoList, id: \.0, editActions: .delete){
                            $item in
                            HStack{
                                Checkbox(isChecked: $item.1.isCompleted) {
                                    viewModel.saveTodo(entityId: item.0, todo: item.1)
                                    viewModel.cloneRecurringTodoIfNecessary(entityId: item.0, todo: item.1)
                                }
                                NavigationLink(destination: TodoDetail(entityId: item.0)){
                                    HStack {
                                        Text(item.1.task)
                                        Spacer()
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }.listStyle(.insetGrouped)
            
            HStack {
                Picker(selection: $viewModel.filter, label: Text("Filter"), content: {
                    ForEach(FilterType.allCases, id: \.self) { v in
                        Text(v.localizedName).tag(v)
                    }
                }).onChange(of: viewModel.filter) { newFilter in
                    viewModel.loadList(filter: newFilter)
                }
                NavigationLink {
                    CreateTodoView()
                } label: {
                    Text("Add").padding()
                }
            }
            .padding()
        }.alert("Error: \(self.viewModel.error?.localizedDescription ?? "")", isPresented: $viewModel.showAlert) {
            Button("Ok", role: .cancel){
                self.viewModel.showAlert = false;
                self.viewModel.error = nil
            }
        }.toolbar {
            EditButton()
        }.navigationTitle("Today")
    }
    
    var header: some View {
        VStack(alignment: .center) {
            Text("\(Int(viewModel.progress * 100))%")
                .font(.system(size: 50, weight: .ultraLight, design: .rounded))
            Text("completed")
                .font(.system(size: 18, design: .rounded)).textCase(.uppercase)
        }
        .frame(width: UIScreen.main.bounds.width)
//        HStack(alignment: .center) {
//                Text("Today")
//                    .font(.system(size: 50, weight: .ultraLight, design: .rounded))
//                    .frame(width: UIScreen.main.bounds.width * 0.6)
//
//        }.padding(.top, 50)
    }
    
    func emptyView()-> AnyView {
        
        if viewModel.todoList.isEmpty {
                switch(viewModel.filter){
                case .all: return AnyView(VStack{
                    
                    NavigationLink {
                        CreateTodoView()
                    } label: {
                        Label("New Todo", systemImage: "plus")
                    }.buttonStyle(.bordered)
                })
                case .incomplete: return AnyView(Text("No incomplete todos"))
                case .completed: return AnyView(Text("No completed todos"))
                }
        }
        return AnyView(EmptyView())
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}

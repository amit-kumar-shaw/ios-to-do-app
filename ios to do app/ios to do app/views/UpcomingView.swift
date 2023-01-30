//
//  TodoView.swift
//  ios to do app
//
//  Created by Shivam Singh Rajput on 10.01.23.
//

import Foundation
import SwiftUI




struct UpcomingView: View {
    @ObservedObject var viewModel = UpcomingViewModel()
    @Environment(\.tintColor) var tintColor
    @Environment(\.editMode) var editMode

    var body: some View {
        VStack {
            List(selection: $viewModel.selection) {
            Section{
                header
            }
            
               Section{
                   ForEach($viewModel.todoList, id: \.0) { $item in
                       TodoRow(item: $item).onChange(of: item.1.isCompleted) { newValue in
                           viewModel.saveTodo(entityId: item.0, todo: item.1)
                           viewModel.cloneRecurringTodoIfNecessary(entityId: item.0, todo: item.1)
                       }
                   }
                   .onDelete { indexSet in
                       viewModel.todoList.remove(atOffsets: indexSet)
                   }
               }
            }.listStyle(.insetGrouped)
            
            bottomBar
            
        }.alert("Error: \(self.viewModel.error?.localizedDescription ?? "")", isPresented: $viewModel.showAlert) {
            Button("Ok", role: .cancel){
                self.viewModel.showAlert = false;
                self.viewModel.error = nil
            }
        }.toolbar {
            EditButton()
        }.navigationTitle("Upcoming").onAppear {
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(tintColor)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        }
    }
    
    var header: some View {
        VStack(alignment: .center) {
            Text("\(Int(viewModel.progress * 100))%")
                .font(.system(size: 50, weight: .ultraLight, design: .rounded))
            Text("completed")
                .font(.system(size: 18, design: .rounded))
            Picker(selection: $viewModel.selectedWeekday) {
                ForEach(WEEKDAYS.indices, id: \.self) { index in
                    Text(WEEKDAYS[index].prefix(3))
                }
            } label: {
                EmptyView()
            }.pickerStyle(.segmented).padding(.horizontal,30)
        }.frame(width: UIScreen.main.bounds.width)
        
    }
    
    var bottomBar: some View {
        HStack {
            
            if editMode?.wrappedValue == .active{
                
                Spacer()
                VerticalLabelButton("Project", systemImage: "folder.fill", action: {
                    viewModel.showMoveToProject = true
                }).sheet(isPresented: $viewModel.showMoveToProject) {
                    SelectProjectView { projectId, _ in
                        viewModel.selectionMoveToProject(projectId: projectId)
                    }
                }
                Spacer()
                VerticalLabelButton("Priority", systemImage: "exclamationmark.circle.fill") {
                    viewModel.showChangePriority = true
                }.sheet(isPresented: $viewModel.showChangePriority) {
                    SelectPriorityView(priority: .medium) { newPriority in
                        viewModel.selectionChangePriority(newPriority: newPriority)
                    }
                }
                Spacer()
                VerticalLabelButton("Due date", systemImage: "calendar.badge.clock") {
                    viewModel.showChangeDueDate = true
                }.sheet(isPresented: $viewModel.showChangeDueDate) {
                    SelectDueDateView(date: Date()) { newDate in
                        viewModel.selectionChangeDueDate(newDueDate: newDate)
                    }
                }
                Spacer()
            }else{
                Picker(selection: $viewModel.filter, label: Text("Filter"), content: {
                    ForEach(FilterType.allCases, id: \.self) { v in
                        Text(v.localizedName).tag(v)
                    }
                }).onChange(of: viewModel.filter) { newFilter in
                    if let lsd = viewModel.lastStartDate, let led = viewModel.lastEndDate{
                        viewModel.loadList(filter: newFilter, startDate: lsd, endDate: led)
                    }
                }
                Spacer()
                NavigationLink {
                    CreateTodoView()
                } label: {
                    Text("Add")
                    
                }
            }
        }.padding(.horizontal, 20)
    }
}

struct UpcomingView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingView()
    }
}


//
//  TodoView.swift
//  ios to do app
//
//  Created by Shivam Singh Rajput on 10.01.23.
//

import Foundation
import SwiftUI

import SlideOverCard

struct UpcomingView: View {
    @ObservedObject var viewModel = UpcomingViewModel()
    @Environment(\.tintColor) var tintColor

    var body: some View {
        List {
            Section{
                header
            }
            
            Section{
                ForEach($viewModel.todoList, id: \.0) { $item in
                    HStack {
                        Checkbox(isChecked: $item.1.isCompleted) {
                            viewModel.saveTodo(entityId: item.0, todo: item.1)
                        }
                        NavigationLink(destination: TodoDetail(entityId: item.0)) {
                            HStack {
                                Text(item.1.task)
                                Spacer()
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    viewModel.todoList.remove(atOffsets: indexSet)
                }
            }
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
}

struct UpcomingView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingView()
    }
}

//
//  ToDoListView.swift
//  MVVMExample
//
//  Created by BATCH02L1 on 12/12/25.
//

import SwiftUI
struct ToDoListView: View{
    @ObservedObject var viewModel = ToDoListViewModel()
    @State private var newToDoTitle:String=""
    var body: some View{
        TextField("New ToDo",text: $newToDoTitle)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        Button("Add ToDo"){
            viewModel.addTodoitem(newToDoTitle)
            newToDoTitle=""
        }
        List{
            ForEach(viewModel.todoitems){
                item in
                HStack{
                    Text(item.title).strikethrough(item.isCompleted,color: .black)
                        Spacer()
                    Button(action: {
                        viewModel.toggleCompletion(for: item)
                    })
                    {
                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    }
                    
                }
            }
            .onDelete(perform: viewModel.deleteTodoitem)
        }
    }
}
#Preview {
    ToDoListView()
}

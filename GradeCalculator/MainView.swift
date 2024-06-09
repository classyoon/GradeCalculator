//
//  MainView.swift
//  GradeCalculator
//
//  Created by Conner Yoon on 6/7/24.
//
import SwiftData
import SwiftUI
@Observable
class GradeCalculator {
    private(set) var assignments : [Assignment] = []
    var averageGrade: Double? {
        var totalGrade = 0.0
        var totalWeight = 0.0
        
        assignments.forEach { assignment in
            totalGrade += (assignment.grade) * (assignment.weight)
            totalWeight += assignment.weight
        }
        
        if totalWeight == 0 {
            return nil
        } else {
            return totalGrade / totalWeight
        }
    }
    func addAssignment() {
        assignments.append(Assignment())
    }
    func deleteItems(offsets: IndexSet) {
        for index in offsets {
            assignments.remove(at: index)
        }
    }
}

@Observable
class Assignment: Identifiable {
    var id = UUID()
    var name : String
    var grade : Double
    var weight : Double
    init(name: String = "", grade: Double = 0.0, weight: Double = 10.0) {
        self.name = name
        self.grade = grade
        self.weight = weight
    }
}
struct MainView: View {
    @State var vm = GradeCalculator()
    
    private func deleteItems(offsets: IndexSet) {
        vm.deleteItems(offsets: offsets)
    }
    var body: some View {
        NavigationStack{
            Form{
                ForEach(vm.assignments){ assignment in
                    AssignmentRowView(assignment: assignment)
                        .listRowBackground(Color.green)
                }.onDelete(perform: { indexSet in
                    deleteItems(offsets: indexSet)
                })
            }
            //.scrollContentBackground(.hidden)
              //  .background(.white)
            .navigationTitle("Average: \(vm.averageGrade ?? 0.0, specifier: "%.1f")")
                .toolbar {
                    ToolbarItem {
                        Button(action: { 
                            vm.addAssignment()
                        }) {
                            Label("Add Item", systemImage: "plus.circle.fill").font(.title2)
                        }
                    }
                }
        }
    }
}


struct AssignmentRowView : View {
    @Bindable var assignment: Assignment
    
    
    var body: some View {
        HStack {
            TextField("Name", text: $assignment.name)
            TextField("Grade", value: $assignment.grade, format: .number)
            TextField("Weight", value: $assignment.weight, format: .number)
        }.textFieldStyle(.roundedBorder)
    }
}

#Preview {
    MainView()
}

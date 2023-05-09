//
//  MainView.swift
//  practerview
//
//  Created by Minkyeong Ko on 2023/05/05.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Company.company_title, ascending: true)],
        animation: .default)
    private var companies: FetchedResults<Company>
    
    @State var dummy_companies = ["신한은행 2023 상반기", "야놀자 23년 인턴", "카카오페이 상시채용"]
    @State var showAlert = false
    @State private var new_company = ""
    
    var body: some View {
        VStack {
            List {
                // \.self는 도대체 뭘까
                ForEach(companies, id: \.self) { company in
                    NavigationLink("\(company.company_title!)") {
                        PracticeView(companyName: company.company_title!, companyIndex: company.company_index, companyObject: company)
                            .navigationTitle("\(company.company_title!)")
                            .environment(\.managedObjectContext, viewContext)
                    }
                }
                .onDelete(perform: deleteItems)
//                .onMove(perform: moveItems)   // CoreData에 맞게 구현하기
            }
            .scrollContentBackground(.hidden)
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
            
//            VStack {
//                Button(action: {
//                    
//                }, label: {
//                    HStack {
//                        Text("시작하기 전 꼭 읽어주세요!")
//                            .foregroundColor(.white)
//                        Spacer()
//                        Image(systemName: "exclamationmark.triangle.fill")
//                            .foregroundColor(.white)
//                    }
//                    .padding(.horizontal, 30)
//                    .padding(.vertical, 15)
//                    .background(.orange)
//                    .cornerRadius(15)
//                })
//            }
//            .padding(20)
        }
        .navigationTitle("전형 리스트")
        .alert("추가하기", isPresented: $showAlert) {
            TextField("이름", text: $new_company)
            Button("확인", action: addNewCompany)
            Button("취소", role: .cancel) {
                showAlert = false
            }
        } message: {
            Text("면접을 연습할 기업 / 전형 이름을 입력하세요.")
        }
    }
    
    private func addNewCompany() {
//        if new_company != "" {
//            dummy_companies.append(new_company)
//        }
        withAnimation {
            let newCompany = Company(context: viewContext)
            newCompany.company_title = new_company
            newCompany.company_index = Int32(companies.count)

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
    
    private func addItem() {
        // 무슨 화면 띄우기
        showAlert = true
    }
    
    private func deleteItems(offsets: IndexSet) {
//        offsets.forEach { dummy_companies.remove(at: $0) }
        withAnimation {
            offsets.map { companies[$0] }.forEach(viewContext.delete)

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
    
//    private func moveItems(from source: IndexSet, to destination: Int) {
//        dummy_companies.move(fromOffsets: source, toOffset: destination)
//    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

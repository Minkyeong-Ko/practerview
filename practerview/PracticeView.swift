//
//  PracticeView.swift
//  practerview
//
//  Created by Minkyeong Ko on 2023/05/05.
//

import SwiftUI
import SwiftSoup

struct PracticeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var companyName: String
    var companyIndex: Int32
    var companyObject: Company
    @State var got_data = false
    @State var showSheet = false
    @State var copy_pasted = ""
    @State var questions_dict = [Int:String]()
    @State var answers_dict = [Int:String]()
    
    @State var show_answers_bool = [Bool]()
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showSheet = true
                }, label: {
                    HStack {
                        Text("질문과 대답 붙여넣기")
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "doc.fill")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(.green)
                    .cornerRadius(15)
                })
                .sheet(isPresented: $showSheet) {
                    NavigationView {
                        VStack(alignment: .leading) {
//                            Text("노션 글 형식")
//                                .font(.caption)
//                                .foregroundColor(.gray)
                            VStack(alignment: .leading) {
                                Text("아래와 같이 • 질문 (줄바꿈) → 대답\n의 형식을 가지고 있어야 합니다. \n(구분선은 상관 없음)")
//                                Text("• 질문내용 ")
//                                    .font(.subheadline)
//                                Divider()
//                                Text("답변 내용")
//                                    .font(.subheadline)
//                                Text("...(반복)")
//                                    .font(.subheadline)
                                Image("example")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .padding(10)
                            .cornerRadius(20)
                            .border(.gray, width: 0.5)
                            
                            Divider()
                                .opacity(0)
                                .padding(20)
                            
                            Text("입력하기")
                            TextEditor(text: $copy_pasted)
                                .scrollContentBackground(.hidden) // <- Hide it 이렇게 해 줘야 백그라운드 먹음
                                .background(Color(UIColor.systemGray5))
                                .foregroundColor(.blue)
                                .cornerRadius(5)
                        }
                        .padding(15)
                        .navigationTitle("질문과 답 입력")
                        .toolbar {
                            ToolbarItem (placement: .navigationBarLeading) {
                                Button {
                                    showSheet = false
                                } label: {
                                    Text("취소")
                                }
                            }
                            
                            ToolbarItem {
                                Button(action: getNotionContent) {
                                    Text("완료")
                                }
                                .disabled(copy_pasted == "")
                            }
                        }
                    }
                }
                NavigationLink(destination: SimulationView(q: questions_dict, a: answers_dict)) {
                    HStack {
                        Text("시뮬레이션 시작")
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(.yellow)
                    .cornerRadius(15)
                    .opacity(got_data ? 1 : 0.5)
                }
                .disabled(!got_data)
            }
            .padding(20)
            
            Spacer()
            
            if !got_data {
                Text("아직 불러온 데이터가 없습니다")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            } else {
                List {
//                    Section (header: Text("카테고리?")) {
                    ForEach(Array(questions_dict.keys), id: \.self) { idx in
                            VStack (alignment: .leading) {
                                HStack {
                                    Text("Q: \(questions_dict[idx]!)")
                                        .font(.system(size: 16))
                                        .fontWeight(Font.Weight.bold)
                                    
                                    Spacer()
                                    
                                    if show_answers_bool.count > 0 {
                                        Button {
                                            show_answers_bool[idx-1].toggle()
                                        } label: {
                                            show_answers_bool[idx-1] ? Image(systemName: "arrowtriangle.up.fill") : Image(systemName: "arrowtriangle.down.fill")
                                        }
                                    }
                                }
                                .padding(.bottom, 10)
                                
                                if show_answers_bool.count > 0 {
                                    HStack {
                                        if show_answers_bool[idx-1] {
                                            Text(answers_dict[idx] != nil ? "A: \(answers_dict[idx]!)" : "입력된 답변 없음")
                                                .font(.system(size: 15))
                                        } else {
                                            EmptyView()
                                        }
                                    }
                                }
                            }
//                        }
                    }
                }
//                .scrollContentBackground(.hidden)
                .listStyle(SidebarListStyle())
            }
        
            Spacer()
        }
        
        .onAppear {
            if companyObject.questions != nil {
                got_data = true
            }
            
            show_answers_bool = Array(repeating: false, count: companyObject.questions?.count ?? 0)
            
            let questionsIndexs: [Int] = companyObject.questions_indexes ?? []
            questionsIndexs.forEach { idx in
                questions_dict[idx] = companyObject.questions?[idx-1]
            }
            let answersIndexes: [Int] = companyObject.answers_indexes ?? []
            answersIndexes.forEach { idx in
                answers_dict[idx] = companyObject.answers?[idx-1]
            }
            
        }
//        .padding(20)
    }
    
    private func getNotionContent() {
        // 필요 없는 거 전부 삭제
        var filtered = copy_pasted.filter{$0 != "*"}
        filtered = filtered.replacingOccurrences(of: "---", with: "")
        
        // 질문 저장
        var questionsDict = [Int:String]()
        // 답변 저장 (꼭 1대1 대응일 필요 없음)
        var answersDict = [Int:String]()
        
        var question_index = 0
        var make_question = ""
        
        // 줄바꿈을 기준으로 split
        let splited_2 = filtered.split(separator: "\n")
        
        // 여러 문단으로 된 문장들 저장하기 위한 변수
        var previous = ""
        
        for element in splited_2 {
            var str = String(element)
            str = str.trimmingCharacters(in: .whitespaces)  // 앞뒤 공백 제거
            
            if str == "" {
                continue
            }
            if str.first == "-" {
                question_index += 1
                questionsDict[question_index] = String(str.suffix(str.count - 2))
                previous = "-"
            } else if str.first == "→" {
                answersDict[question_index] = String(str.suffix(str.count - 2))
                previous = "→"
            } else {
                if previous == "→" {
                    answersDict[question_index]! += String("\n\(str)")
                } else {
                    questionsDict[question_index]! += String("\n\(str)")
                }
            }
        }
        
        questions_dict = questionsDict
        answers_dict = answersDict
        
        var questions_keys = [Int]()
        var questions_values = [String]()
        questionsDict.forEach {
            questions_keys.append($0.key)
            questions_values.append($0.value)
        }
        
        var answers_keys = [Int]()
        var answers_values = [String]()
        answersDict.forEach {
            answers_keys.append($0.key)
            answers_values.append($0.value)
        }
        
        // 참고로 Transformer에서 NSSecureUnarchiveFromData와 같은 설정을 안 해주면, 해당 속성에 접근할 때마다 "'NSKeyedUnarchiveFromData' should not be used to for un-archiving and will be removed in a future release"라는 경고가 뜨게 되므로, 지금 설정해주어야 한다.
        
        companyObject.questions = questions_values
        companyObject.questions_indexes = questions_keys
        companyObject.answers = answers_values
        companyObject.answers_indexes = answers_keys
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            print(error)
        }

        got_data = true
        showSheet = false
    }
}

//struct PracticeView_Previews: PreviewProvider {
//    static var previews: some View {
//        PracticeView(companyName: "테스트 회사", companyIndex: 1, companyObject: $Company())
//    }
//}

//
//  SimulationView.swift
//  practerview
//
//  Created by Minkyeong Ko on 2023/05/06.
//

import SwiftUI

struct SimulationView: View {
    var questions_dict: [Int:String]
    var answers_dict: [Int:String]
    
    @State var tabIndex = 1
    @State var show_answers_bool: [Bool]
    
    init(q: [Int:String], a: [Int:String]) {
        self.questions_dict = q
        self.answers_dict = a
        self.show_answers_bool = Array(repeating: false, count: q.count)
        print("init")
        print(show_answers_bool)
        print(q)
    }
    
    var body: some View {
        VStack {            
            NavigationLink(destination: {
                VStack {
                    TabView {
                        ForEach(Array(questions_dict.keys.sorted()), id: \.self) { index in
                            VStack {
//                                Text("\(index)/\(questions_dict.count)")
//                                Text(questions_dict[index]!)
//                                Button {
//                                    show_answers_bool[index-1].toggle()
//                                } label: {
//                                    Text("토글")
//                                }
                                HStack {
                                    Text("Q: \(questions_dict[index]!)")
                                        .font(.system(size: 16))
                                        .fontWeight(Font.Weight.bold)
                                    
                                    Spacer()
                                    
                                    Button {
                                        show_answers_bool[index-1].toggle()
                                    } label: {
                                        show_answers_bool[index-1] ? Image(systemName: "arrowtriangle.up.fill") : Image(systemName: "arrowtriangle.down.fill")
                                    }
                                }
                                .padding(.bottom, 10)
                                
                                Divider()
                                
                                HStack {
                                    if show_answers_bool[index-1] {
                                        Text(answers_dict[index] != nil ? "A: \(answers_dict[index]!)" : "입력된 답변 없음")
                                            .font(.system(size: 15))
                                    } else {
                                        EmptyView()
                                    }
                                }
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                }
                .padding(20)
            }, label: {
                HStack {
                    Text("순서대로 시작")
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "list.number")
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(.black)
                .cornerRadius(15)
            })
            
            NavigationLink(destination: {
                VStack {
                    TabView {
                        ForEach(Array(questions_dict.keys), id: \.self) { index in
                            VStack {
//                                Text("\(index)/\(questions_dict.count)")
//                                Text(questions_dict[index]!)
//                                Button {
//                                    show_answers_bool[index-1].toggle()
//                                } label: {
//                                    Text("토글")
//                                }
                                HStack {
                                    Text("Q: \(questions_dict[index]!)")
                                        .font(.system(size: 16))
                                        .fontWeight(Font.Weight.bold)
                                    
                                    Spacer()
                                    
                                    Button {
                                        show_answers_bool[index-1].toggle()
                                    } label: {
                                        show_answers_bool[index-1] ? Image(systemName: "arrowtriangle.up.fill") : Image(systemName: "arrowtriangle.down.fill")
                                    }
                                }
                                .padding(.bottom, 10)
                                
                                Divider()
                                
                                HStack {
                                    if show_answers_bool[index-1] {
                                        Text(answers_dict[index] != nil ? "A: \(answers_dict[index]!)" : "입력된 답변 없음")
                                            .font(.system(size: 15))
                                    } else {
                                        EmptyView()
                                    }
                                }
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                }
                .padding(20)
            }, label: {
                HStack {
                    Text("랜덤 순서로 시작")
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "shuffle")
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(.blue)
                .cornerRadius(15)
            })
        }
        .navigationTitle("면접 연습")
        .padding(20)
    }
}

//struct SimulationView_Previews: PreviewProvider {
//    static var previews: some View {
//        SimulationView()
//    }
//}

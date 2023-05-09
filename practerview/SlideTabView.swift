////
////  SlideTabView.swift
////  practerview
////
////  Created by Minkyeong Ko on 2023/05/09.
////
//
//import SwiftUI
//
//struct SlideTabView: View {
//    @Binding var tabIndex: Int
//    var questions_dict: [Int:String]
//    var answers_dict: [Int:String]
//    
//    var body: some View {
//        TabView(selection: $tabIndex) {
//            ForEach(Array(questions_dict.keys.sorted()), id: \.self) { index in
//                
//                // 이 방식 좀 별로..
//                let _ = tabIndex = index - 1
//                VStack {
////                                Text("\(index)/\(questions_dict.count)")
////                                Text(questions_dict[index]!)
//                    
//                    HStack {
//                        Text("Q: \(questions_dict[index]!)")
//                            .font(.system(size: 16))
//                            .fontWeight(Font.Weight.bold)
//                        
//                        Spacer()
//                        
//                        Button {
//                            show_answers_bool[index-1].toggle()
//                        } label: {
//                            show_answers_bool[index-1] ? Image(systemName: "arrowtriangle.up.fill") : Image(systemName: "arrowtriangle.down.fill")
//                        }
//                    }
//                    .padding(.bottom, 10)
//                    
//                    Divider()
//                    HStack {
//                        if show_answers_bool[index-1] {
//                            Text(answers_dict[index] != nil ? "A: \(answers_dict[index]!)" : "입력된 답변 없음")
//                                .font(.system(size: 15))
//                        } else {
//                            EmptyView()
//                        }
//                    }
//                }
//            }
//        }
//        .tabViewStyle(PageTabViewStyle())
//    }
//}
//
//struct SlideTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        SlideTabView()
//    }
//}

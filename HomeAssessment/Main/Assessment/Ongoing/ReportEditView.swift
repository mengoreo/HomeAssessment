//
//  ReportEditView.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/3/13.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import SwiftUI
// @Published var elderCondition = "B 先生，90岁，思维清晰，眼花，耳背，依靠助行器或拐杖，五年前在家中跌倒导致股骨头粉碎，起身困难。家中无保护措施。家中有妻子照顾，同时雇有保姆。"
// @Published var houseCondition = "房屋属于30年以上的多层住宅，位于二层，室内采光通风较差，室内昏暗。物品堆放杂乱，空间内家具摆放等极易对老人通过造成不便。"
// @Published var problems: [String] = [
//     "老年人从卧床到坐起需要辅助。从床上到下地站起没有扶手，有危险。",
//     "床边需要有放衣服的椅子，方便脱衣服，但是椅子是带有滑轮的办公椅，对于老年人非常危险。",
//     "马桶没有扶手助力保护，老年人如厕坐下和起身都很有可能有危险。",
//     "沐浴房比较小，而且底座太高，出入有门槛，护理人员进不去，无法助浴，没有安全扶手，万一发生危险无法施救。", ]

class ReportEditViewModel: NSObject, ObservableObject {
    var title = ""
    let employees: [String]
    let assessment: Assessment
    @Published var elderCondition = ""
    @Published var houseCondition = ""
    @Published var problems = [String]()
    @Published var showEditView = false
    @Published var aboutToEdit = ""
    @Published var editing: [Bool]!
    @Published var height: [CGFloat]!
    init(_ assessment: Assessment, coworker: String = "") {
        self.assessment = assessment
        self.employees = [assessment.user.name, coworker]
        super.init()
        title = assessment.remarks
//        elderCondition = assessment.elders?.map {
//            $0.name + "，" + $0.status
//        }.joined(separator: "；") ?? ""
        elderCondition = "B 先生，90岁，思维清晰，眼花，耳背，依靠助行器或拐杖，五年前在家中跌倒导致股骨头粉碎，起身困难。家中无保护措施。家中有妻子照顾，同时雇有保姆。"
        houseCondition = "房屋属于30年以上的多层住宅，位于二层，室内采光通风较差，室内昏暗。物品堆放杂乱，空间内家具摆放等极易对老人通过造成不便。"
//        houseCondition = "请描述居室基本状况"
//        problems = assessment.selectedOptions.values.map { optionID in
//            Option.findById(with: optionID)?.suggestion ?? ""
//        }
        problems = [
        "老年人从卧床到坐起需要辅助。从床上到下地站起没有扶手，有危险。",
        "床边需要有放衣服的椅子，方便脱衣服，但是椅子是带有滑轮的办公椅，对于老年人非常危险。",
        "马桶没有扶手助力保护，老年人如厕坐下和起身都很有可能有危险。",
        "沐浴房比较小，而且底座太高，出入有门槛，护理人员进不去，无法助浴，没有安全扶手，万一发生危险无法施救。", ]
        editing = Array<Bool>(repeating: false, count: problems.count + 2)
        height = Array<CGFloat>(repeating: 0, count: problems.count + 2)
    }
    
    // MARK: - ReportEditViewModel
    func show(_ index: Int) -> Bool {
        for i in editing.indices {
            if editing[i] && i != index {
                return false
            }
        }
        return true
    }
    func showProblemHeader() -> Bool {
        for i in 2..<editing.count {
            if show(i) {
                return true
            }
        }
        return false
    }
    
    func showNextButton() -> Bool {
        for e in editing {
            if e {
                return false
            }
        }
        return true
    }
    
}
struct ReportEditView: View {
    @ObservedObject var viewModel: ReportEditViewModel
    @State var show = false
    
    var body: some View {
            
        ScrollView(.vertical, showsIndicators: true) {
            // MARK: - ReportEditView
            VStack(alignment: .leading, spacing: 7) {
                Text("老人基本状况")
                    .font(.caption)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                UITextViewWrapper(text: $viewModel.elderCondition, calculatedHeight: $viewModel.height[0], editing: $viewModel.editing[0])
                    .frame(height: viewModel.height[0])
                    .padding(3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 13)
                            .strokeBorder(
                                viewModel.editing[0] ? Color.lightGreen : Color.gray,
                                lineWidth: 1)
                    )
            }
            .frame(height: viewModel.show(0) ? viewModel.height[0] + 20 : 0)
            .opacity(viewModel.show(0) ? 1 : 0)
            .padding(.top, 20)
            .padding(.horizontal, 20)

            VStack(alignment: .leading, spacing: 7) {
                Text("居家基本状况")
                    .font(.caption)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                UITextViewWrapper(text: $viewModel.houseCondition, calculatedHeight: $viewModel.height[1], editing: $viewModel.editing[1])
                    .frame(height: viewModel.height[1])
                    .padding(3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 13)
                            .strokeBorder(
                                viewModel.editing[1] ? Color.lightGreen : Color.gray,
                                lineWidth: 1)
                    )
            }.frame(height: viewModel.show(1) ? viewModel.height[1] + 20 : 0)
            .opacity(viewModel.show(1) ? 1 : 0)
            .padding(.top, 20)
            .padding(.horizontal, 20)

            

            VStack(alignment: .leading, spacing: 7) {
                Text("存在问题")
                    .font(.caption)
                    .foregroundColor(Color(UIColor.secondaryLabel))

                ForEach(viewModel.problems.indices) { index in
                    if self.viewModel.show(index + 2) {
                    HStack {
                        Text("\(index + 1): ")
                        UITextViewWrapper(text: self.$viewModel.problems[index],
                                          calculatedHeight: self.$viewModel.height[index + 2],
                                          editing: self.$viewModel.editing[index + 2])
                            .frame(height: self.viewModel.height[index + 2])
                            .padding(3)
                            .overlay(
                                RoundedRectangle(cornerRadius: 13)
                                    .strokeBorder(
                                        self.viewModel.editing[index + 2] ? Color.lightGreen : Color.gray,
                                        lineWidth: 1)
                            )
                    }
                    }
                }
            }
            .opacity(viewModel.showProblemHeader() ? 1 : 0)
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
                
            NavigationLink(destination:
                ReportView(viewModel: .init(assessment: viewModel.assessment,
                                            title: viewModel.title,
                                            employees: viewModel.employees,
                                            elderCondition: viewModel.elderCondition,
                                            houseCondition: viewModel.houseCondition,
                                            problems: viewModel.problems)),
                           isActive: $show
            ) {
                Text("")
            }.hidden()
            
            
        }
        .navigationBarTitle("编辑报告", displayMode: .inline)
        .navigationBarItems(trailing: Button("下一步") {self.show = true})
        .animation(.default)
    }
}


fileprivate struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    @Binding var editing: Bool
    

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        
        let textField = UITextView()
        textField.delegate = context.coordinator

        textField.isEditable = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        
        textField.backgroundColor = UIColor.clear
        textField.returnKeyType = .done
        
        textField.text = text
        let height = textField.sizeThatFits(.init(width: Device.width - 50, height: .greatestFiniteMagnitude)).height
        textField.isScrollEnabled = height > 100
        calculatedHeight = min(height, 100)
    
        
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        //
    }

    func recalculateHeight(view: UITextView) {
        print("recalculateHeight")
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        
            DispatchQueue.main.async {
                if newSize.height > 100 {
                    view.isScrollEnabled = true
                }
                self.calculatedHeight = min(newSize.height, 100) // !! must be called asynchronously
            }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var parent: UITextViewWrapper

        init(_ parent: UITextViewWrapper) {
            self.parent = parent
        }

        func textViewDidChange(_ uiView: UITextView) {
            print("textViewDidChange")
            parent.text = uiView.text
            parent.recalculateHeight(view: uiView)
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            print("textViewDidBeginEditing")
            parent.recalculateHeight(view: textView)
            parent.editing = true
        }
        func textViewDidEndEditing(_ textView: UITextView) {
            print("textViewDidEndEditing")
            parent.recalculateHeight(view: textView)
//            parent.calculatedHeight = 100
            parent.editing = false
        }
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            print("change range", range)
            if text == "\n" {
                textView.resignFirstResponder()
                parent.editing = false
                return false
            }
            return true
        }
    }

}

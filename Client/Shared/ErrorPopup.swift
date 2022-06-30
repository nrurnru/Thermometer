//
//  ErrorPopup.swift
//  Thermometer
//
//  Created by 최광현 on 2022/06/25.
//

import SwiftUI
import Combine

struct ErrorPopup: View {
    @ObservedObject var viewModel: ErrorPopupViewModel
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                Text("에러가 발생했습니다. 에러: \(viewModel.error.description)")
                Toggle("테스트 모드로 전환", isOn: $viewModel.isTestModeOn)
                Button("확인") {
                    viewModel.toggleTestmode()
                    viewModel.dismiss()
                }
            }
            .foregroundColor(Color.black)
            .padding(EdgeInsets.init(top: 30, leading: 30, bottom: 30, trailing: 30))
        }.baseFont(size: .middle)
    }
}

class ErrorPopupViewModel: CommonViewModel, PopupViewModel {
    private(set) var error: RepositoryError
    
    @Binding var isPresent: Bool
    @Published var isTestModeOn: Bool = false
    
    init(DI: DI, error: RepositoryError, isPresent: Binding<Bool>) {
        self.error = error
        self._isPresent = isPresent
        super.init(DI: DI)
    }
    
    override func bind() {
        super.bind()
        self.DI.appEnvironment.$isTestMode
            .assign(to: &$isTestModeOn)
    }
    
    func toggleTestmode() {
        if isTestModeOn {
            DI.appEnvironment.enableTestmode()
        } else {
            DI.appEnvironment.disableTestmode()
        }
    }
}

protocol PopupViewModel: AnyObject {
    var isPresent: Bool { get set }
}

extension PopupViewModel {
    func dismiss() {
        self.isPresent = false
    }
}

//
//  CommonViewModel.swift
//  Thermometer
//
//  Created by 최광현 on 2022/06/26.
//

import Combine

class CommonViewModel: ObservableObject {
    @Published var DI: DI
    var bag = Set<AnyCancellable>()
    
    init(DI: DI) {
        self.DI = DI
        self.bind()
    }
    
    func bind() {}
    
    func reBind() {
        self.bag = Set<AnyCancellable>()
        self.bind()
    }
}

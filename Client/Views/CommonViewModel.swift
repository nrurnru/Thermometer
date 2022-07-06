import Combine

class CommonViewModel: ObservableObject {
    @Published var diContainer: DIContainer
    var bag = Set<AnyCancellable>()
    
    init(diContainer: DIContainer) {
        self.diContainer = diContainer
        self.bind()
    }
    
    func bind() {}
    
    func reBind() {
        self.bag = Set<AnyCancellable>()
        self.bind()
    }
}

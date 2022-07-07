import Foundation

protocol PopupViewModel: AnyObject {
    var isPresent: Bool { get set }
}

extension PopupViewModel {
    func dismiss() {
        self.isPresent = false
    }
}

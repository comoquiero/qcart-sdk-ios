import UIKit

class ViewController: UIViewController {

    private let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        textView.frame = view.bounds
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textView.font = .systemFont(ofSize: 20)
        view.addSubview(textView)
    }

    func updateSkus(skus: [(String, Int)]) {
        textView.text = skus.map { "\($0.0): \($0.1)" }.joined(separator: "\n")
    }
}
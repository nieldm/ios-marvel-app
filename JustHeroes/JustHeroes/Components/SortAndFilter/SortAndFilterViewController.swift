import UIKit
import SnapKit

class SortAndFilterViewController: UIViewController {

    let stackView: UIStackView
    let sortButton: UIButton
    
    let viewModel: SortAndFilterViewModelViewProtocol
    let builder: SortAndFilterBuilderProtocol
    
    init(viewModel: SortAndFilterViewModelViewProtocol, builder: SortAndFilterBuilderProtocol) {
        let sort = UIButton(type: .roundedRect)
        stackView = UIStackView(arrangedSubviews: [sort])
        stackView.axis = .horizontal
        sortButton = sort
        self.viewModel = viewModel
        self.builder = builder
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .primary
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(240)
        }
        
        sortButton.backgroundColor = .primary
        sortButton.tintColor = .secondary
        sortButton.setTitle("Sort", for: .normal)
        sortButton.titleLabel?.subheadlineStyle()
        sortButton.addTarget(self, action: #selector(didTapSortOptionButton), for: .touchUpInside)
        sortButton.layer.rounded(withCornerRadius: 10, andBorderWidth: 2)
    }
    
    @objc
    func didTapSortOptionButton() {
        viewModel.didTapSortOption()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SortAndFilterViewController: SortAndFilterViewModelProtocol {
    func showSortOptions(forItems items: [SortFilterModel]) {
        let vc = builder.createSortModule(forItems: items)
        vc.modalPresentationStyle = .automatic
        vc.view.backgroundColor = .primary
        if let parent = parent {
            parent.present(vc, animated: true)
            return
        }
        present(vc, animated: true)
    }
    
    func hideSortOptions() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.presentedViewController?.dismiss(animated: true)
        }
    }
}

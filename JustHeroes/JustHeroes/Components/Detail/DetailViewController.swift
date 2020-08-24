//
//  DetailViewController.swift
//  JustHeroes
//
//  Created by Daniel Mendez on 8/24/20.
//  Copyright © 2020 Daniel Mendez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet private var headerImageView: UIImageView!
    @IBOutlet private var descriptionTextView: UITextView!
    @IBOutlet private var viewContainer: UIView!
    
    private let viewModel: ViewModelViewCycleEvents
    private var childViewController: UIViewController?

    init(viewModel: ViewModelViewCycleEvents, childViewController: UIViewController? = nil) {
        self.viewModel = viewModel
        self.childViewController = childViewController
        if childViewController == nil {
            super.init(nibName: "DetailViewController", bundle: nil)
        } else {
            super.init(nibName: "DetailViewControllerWithChild", bundle: nil)
        }
        
    }
    
    override func viewDidLoad() {
        if let childViewController = childViewController {
            viewContainer.addSubview(childViewController.view)
            addChild(childViewController)
            childViewController.didMove(toParent: self)
            childViewController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        viewModel.viewDidLoad()
        super.viewDidLoad()
        
        headerImageView.layer.rounded()
        view.backgroundColor = .primary
        descriptionTextView.descriptionStyle()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.viewDidDisappear()
        super.viewDidDisappear(animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailViewController: DetailViewModelView {
    func set(image: UIImage) {
        DispatchQueue.main.async {
            self.headerImageView.image = image
        }
    }
    
    func set(model: BaseModel) {
        descriptionTextView.text = model.description
    }
}

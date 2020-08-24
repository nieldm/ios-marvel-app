//
//  DetailViewController.swift
//  JustHeroes
//
//  Created by Daniel Mendez on 8/24/20.
//  Copyright © 2020 Daniel Mendez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let viewModel: ViewModelViewCycleEvents
    @IBOutlet private var headerImageView: UIImageView!
    @IBOutlet private var descriptionLabel: UILabel!

    init(viewModel: ViewModelViewCycleEvents) {
        self.viewModel = viewModel
//        self.headerImageView = UIImageView()
//        self.descriptionLabel = UILabel()
        super.init(nibName: "DetailViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        viewModel.viewDidLoad()
        super.viewDidLoad()
        
        view.backgroundColor = .primary
        
//        view.addSubview(headerImageView)
        headerImageView.clipsToBounds = true
        headerImageView.contentMode = .scaleAspectFill
//        headerImageView.snp.makeConstraints { make in
//            make.top.equalTo(view.snp.topMargin)
//            make.left.right.equalToSuperview()
//            make.height.equalToSuperview().multipliedBy(0.45)
//        }
        
//        view.addSubview(descriptionLabel)
//        descriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(headerImageView.snp.bottom).offset(8)
//            make.left.equalToSuperview().offset(12)
//            make.right.equalToSuperview().inset(12)
//        }
        descriptionLabel.descriptionStyle()
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
        descriptionLabel.text = model.description
    }
}

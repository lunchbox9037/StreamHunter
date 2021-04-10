//
//  WhereToWatchCollectionViewCell.swift
//  uStream
//
//  Created by stanley phillips on 2/23/21.
//

import Foundation
import UIKit

public class WhereToWatchCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    var currentIndexPath: IndexPath? = nil

    // MARK: - Views
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemFill
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.cornerRadius = 12
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 12
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var providerLogoImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.container)
        self.container.addSubview(self.providerLogoImageView)

        NSLayoutConstraint.activate([
            self.container.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.container.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.container.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.providerLogoImageView.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 0),
            self.providerLogoImageView.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: 0),
            self.providerLogoImageView.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 0),
            self.providerLogoImageView.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: 0)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.providerLogoImageView.image = nil
    }
    
    // MARK: - Methods
    func setup(provider: Provider, newIndexPath: IndexPath) {
        self.currentIndexPath = newIndexPath
        WhereToWatchController.fetchLogoFor(provider: provider) { [weak self] (result) in
            switch result {
            case .success(let logo):
                DispatchQueue.main.async {
                    if self?.currentIndexPath == newIndexPath {
                        self?.providerLogoImageView.image = logo
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }//end func
}//end class

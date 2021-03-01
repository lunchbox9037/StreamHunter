//
//  MediaDetailCollectionViewCell.swift
//  uStream
//
//  Created by stanley phillips on 2/23/21.
//

import UIKit

protocol AddToListButtonDelegate: AnyObject {
    func addToList()
}

public class MediaDetailCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    var button: UIButton {return addToListButton}
    weak var delegate: AddToListButtonDelegate?
    
    // MARK: - Views
    var container: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor.systemFi
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var backdropImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var addToListButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to your list?", for: .normal)
        button.backgroundColor = .systemBlue
        button.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(addToListButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    var synopsisLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Synopsis"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .opaqueSeparator
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var overviewLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "overview..."
        label.font = UIFont.preferredFont(forTextStyle: .footnote).withSize(12)
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.container)
        self.container.addSubview(self.backdropImageView)
        self.container.addSubview(self.addToListButton)
        self.container.addSubview(self.synopsisLabel)
        self.container.addSubview(self.overviewLabel)
        activateButton()

        NSLayoutConstraint.activate([
            self.container.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.container.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.container.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.backdropImageView.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 0),
            self.backdropImageView.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 0),
            self.backdropImageView.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: 0),
            self.backdropImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            self.addToListButton.topAnchor.constraint(equalTo: self.backdropImageView.bottomAnchor, constant: 10),
            self.addToListButton.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 0),
            self.addToListButton.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            self.synopsisLabel.topAnchor.constraint(equalTo: self.addToListButton.bottomAnchor, constant: 10),
            self.synopsisLabel.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 12),
            self.synopsisLabel.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: -12),
//            self.subtitleLabel.centerXAnchor.constraint(equalTo: self.backdropImageView.centerXAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            self.overviewLabel.topAnchor.constraint(equalTo: self.synopsisLabel.bottomAnchor, constant: 10),
            self.overviewLabel.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 12),
            self.overviewLabel.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: -12),
            self.overviewLabel.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: -10)
//            self.subtitleLabel.centerXAnchor.constraint(equalTo: self.backdropImageView.centerXAnchor, constant: 0)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activateButton() {
        self.button.addTarget(self, action: #selector(addToListButtonTapped(sender:)), for: .touchUpInside)
    }
    
    // MARK: - Methods
    func setup(media: Media) {

        TrendingMediaController.fetchBackdropImageFor(media: media) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.backdropImageView.image = image
                case .failure(let error):
                    self?.backdropImageView.image = UIImage(systemName: "image")
                    print(error.localizedDescription)
                }
            }
        }
        self.overviewLabel.text = media.overview
    }
    
    @objc func addToListButtonTapped(sender: UIButton) {
        addToListButton.setTitle("Added to List!", for: .normal)
        delegate?.addToList()
    }
}//end class

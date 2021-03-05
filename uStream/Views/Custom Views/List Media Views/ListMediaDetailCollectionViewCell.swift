//
//  ListMediaDetailCollectionViewCell.swift
//  uStream
//
//  Created by stanley phillips on 3/1/21.
//

//
//  MediaDetailCollectionViewCell.swift
//  uStream
//
//  Created by stanley phillips on 2/23/21.
//

import UIKit

protocol ListMediaDetailButtonDelegate: AnyObject {
    func moreWatchOptions()
}

public class ListMediaDetailCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    var moreOptionsButton: UIButton {return moreWaysToWatchButton}
    var homeButton: UIButton {return launchHomeButton}
    
    weak var delegate: ListMediaDetailButtonDelegate?
    
    // MARK: - Views
    var container: UIView = {
        let view = UIView()
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
    
    var buttonStackView : UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 6
        
        return stackView
    }()
    
    var moreWaysToWatchButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" More Watch Options...", for: .normal)
        button.setImage(UIImage(systemName: "link"), for: .normal)
        button.tintColor = .white
        button.titleEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline).withSize(12)
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        button.backgroundColor = .systemBlue
        button.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 10
        return button
    }()
    
    var launchHomeButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" Open Home?", for: .normal)
        button.setImage(UIImage(systemName: "homekit"), for: .normal)
        button.tintColor = .systemYellow
        button.titleEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline).withSize(12)
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        button.backgroundColor = .systemBlue
        button.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 10
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
        self.container.addSubview(self.buttonStackView)
        self.buttonStackView.addArrangedSubview(self.launchHomeButton)
        self.buttonStackView.addArrangedSubview(self.moreWaysToWatchButton)
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
            self.buttonStackView.topAnchor.constraint(equalTo: self.backdropImageView.bottomAnchor, constant: 10),
            self.buttonStackView.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 0),
            self.buttonStackView.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: 0),
            self.buttonStackView.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        NSLayoutConstraint.activate([
            self.synopsisLabel.topAnchor.constraint(equalTo: self.buttonStackView.bottomAnchor, constant: 10),
            self.synopsisLabel.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 12),
            self.synopsisLabel.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: -12),
        ])
        
        NSLayoutConstraint.activate([
            self.overviewLabel.topAnchor.constraint(equalTo: self.synopsisLabel.bottomAnchor, constant: 10),
            self.overviewLabel.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 12),
            self.overviewLabel.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: -12),
            self.overviewLabel.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setup(media: ListMedia, link: String?) {
        MediaController.fetchBackdropImageForList(media: media) { [weak self] (result) in
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
    
    func activateButton() {
        self.moreOptionsButton.addTarget(self, action: #selector(moreButtonTapped(sender:)), for: .touchUpInside)
        self.homeButton.addTarget(self, action: #selector(launchHomeApp), for: .touchUpInside)
    }

    @objc func moreButtonTapped(sender: UIButton) {
        delegate?.moreWatchOptions()
    }
    
    @objc func launchHomeApp() {
        if let url = URL(string: "com.apple.home://") {
            UIApplication.shared.open(url)
        } else {
            print("error with Home App URL")
        }
    }
    
//    func enableButton() {
//        moreWaysToWatchButton.setTitle("Add to your List?", for: .normal)
//        moreWaysToWatchButton.backgroundColor = .systemBlue
//        moreWaysToWatchButton.isEnabled = true
//    }

    func disableButton() {
        moreOptionsButton.setTitle("No watch options...", for: .normal)
        moreOptionsButton.backgroundColor = .systemGray
        moreOptionsButton.isEnabled = false
    }
}//end class


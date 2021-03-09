//
//  ListMediaDetailCollectionViewCell.swift
//  uStream
//
//  Created by stanley phillips on 3/1/21.
//

import UIKit

protocol MoreWatchOptionsDelegate: AnyObject {
    func moreWatchOptions(_ sender: ListMediaDetailCollectionViewCell)
}

public class ListMediaDetailCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    var moreOptionsButton: UIButton {return moreWaysToWatchButton}
    var homeButton: UIButton {return launchHomeButton}
    var isReminder: Bool = false
    
    weak var delegate: MoreWatchOptionsDelegate?
    
    // MARK: - Views
    var container: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.cornerRadius = 10
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var backdropImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    var buttonStackView : UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        return stackView
    }()
    
    var labelStackView : UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        return stackView
    }()
    
    var moreWaysToWatchButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" More Stream Options...", for: .normal)
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
    
    var releaseDateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "release date"
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .tertiaryLabel
        label.numberOfLines = 0
        label.textAlignment = .left
        label.minimumScaleFactor = CGFloat(0.5)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var synopsisLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Synopsis"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .systemGray2
        label.numberOfLines = 1
        label.textAlignment = .right
        

        label.minimumScaleFactor = CGFloat(0.5)
        label.adjustsFontSizeToFitWidth = true
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
        self.container.addSubview(self.labelStackView)
        self.buttonStackView.addArrangedSubview(self.launchHomeButton)
        self.buttonStackView.addArrangedSubview(self.moreWaysToWatchButton)
        self.labelStackView.addArrangedSubview(self.synopsisLabel)
        self.labelStackView.addArrangedSubview(self.releaseDateLabel)
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
            self.backdropImageView.heightAnchor.constraint(equalTo: self.backdropImageView.widthAnchor, multiplier: 0.25, constant: 125)
        ])
        
        NSLayoutConstraint.activate([
            self.buttonStackView.topAnchor.constraint(equalTo: self.backdropImageView.bottomAnchor, constant: 10),
            self.buttonStackView.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 0),
            self.buttonStackView.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: 0),
            self.buttonStackView.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        NSLayoutConstraint.activate([
            self.labelStackView.topAnchor.constraint(equalTo: self.buttonStackView.bottomAnchor, constant: 10),
            self.labelStackView.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 0),
            self.labelStackView.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            self.overviewLabel.topAnchor.constraint(equalTo: self.labelStackView.bottomAnchor, constant: 10),
            self.overviewLabel.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 12),
            self.overviewLabel.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: -12),
            self.overviewLabel.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setup(media: ListMedia) {
        if let releaseDate = media.releaseDate {
            if releaseDate > Date() {
                makeRemindMeButton()
            }
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                if request.identifier == String(media.id) {
                    DispatchQueue.main.async {
                        self.disableButton()
                    }
                }
            }
        })
        
        MediaController.fetchBackdropImageForList(media: media) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.backdropImageView.image = image
                case .failure(let error):
                    self?.backdropImageView.image = UIImage(systemName: "imageNotAvailable")
                    print(error.localizedDescription)
                }
            }
        }
        self.overviewLabel.text = media.overview
        self.releaseDateLabel.text = "\(media.releaseDate?.dateToString(format: .monthDayYear) ?? "tbd")"
        guard let date = media.releaseDate else {return}
        if date > Date() {
            releaseDateLabel.textColor = .systemGreen
        } else {
            releaseDateLabel.textColor = .tertiaryLabel
        }
    }
    
    func activateButton() {
        self.moreOptionsButton.addTarget(self, action: #selector(moreButtonTapped(sender:)), for: .touchUpInside)
        self.homeButton.addTarget(self, action: #selector(launchHomeApp), for: .touchUpInside)
    }
    
    @objc func disableButton() {
        moreOptionsButton.isEnabled = false
        moreOptionsButton.setImage(UIImage(systemName: "checkmark"), for: .disabled)
        moreOptionsButton.setTitle(" Reminder Set!", for: .disabled)
        moreOptionsButton.tintColor = .systemGreen
        moreOptionsButton.backgroundColor = .systemGray2
    }
    
    func makeRemindMeButton() {
        moreOptionsButton.setTitle(" Remind Me", for: .normal)
        moreOptionsButton.setImage(UIImage(systemName: "exclamationmark.bubble"), for: .normal)
    }

    @objc func moreButtonTapped(sender: UIButton) {
        delegate?.moreWatchOptions(self)
    }
    
    @objc func launchHomeApp() {
        if let url = URL(string: "com.apple.iosremote://") {
            UIApplication.shared.open(url)
        } else {
            print("error with Home App URL")
        }
    }
}//end class


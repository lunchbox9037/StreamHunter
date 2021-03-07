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
    var addButton: UIButton {return addToListButton}
    
    weak var addDelegate: AddToListButtonDelegate?
    
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
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var addToListButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  Add to your list?", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        button.backgroundColor = .systemBlue
        button.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 10
        return button
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
    
    var synopsisLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Synopsis"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .systemGray2
        label.numberOfLines = 0
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        self.container.addSubview(self.labelStackView)
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
            self.backdropImageView.heightAnchor.constraint(equalToConstant: 241)
        ])
        
        NSLayoutConstraint.activate([
            self.addToListButton.topAnchor.constraint(equalTo: self.backdropImageView.bottomAnchor, constant: 10),
            self.addToListButton.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 0),
            self.addToListButton.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: 0),
            self.addToListButton.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        NSLayoutConstraint.activate([
            self.labelStackView.topAnchor.constraint(equalTo: self.addToListButton.bottomAnchor, constant: 10),
            self.labelStackView.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 0),
            self.labelStackView.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: 0),
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
    func setup(media: Media) {
        ListMediaController.shared.fetchListMedia()
        if (ListMediaController.shared.listMedia.contains { (listmedia) -> Bool in
            return listmedia.id == media.id ?? 0
        }) {
            disableButton()
        } else {
            enableButton()
        }
        
        MediaController.fetchBackdropImageFor(media: media) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.backdropImageView.image = image
                case .failure(let error):
                    self?.backdropImageView.image = UIImage(systemName: "imageNotAvailabe")
                    print(error.localizedDescription)
                }
            }
        }
        self.overviewLabel.text = media.overview
        let date = media.convertToDate(media)
        self.releaseDateLabel.text = "\(date.dateToString(format: .monthDayYear))"
    }
    
    func activateButton() {
        self.addButton.addTarget(self, action: #selector(addToListButtonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc func addToListButtonTapped(sender: UIButton) {
        disableButton()
        addDelegate?.addToList()
    }
    
    func enableButton() {
        addToListButton.setTitle(" Add to your List?", for: .normal)
        addToListButton.backgroundColor = .systemBlue
        addToListButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addToListButton.tintColor = .white
        addToListButton.isEnabled = true
    }
    
    func disableButton() {
        addToListButton.setTitle(" Added to List!", for: .normal)
        addToListButton.setImage(UIImage(systemName: "checkmark"), for: .disabled)
        addToListButton.tintColor = .systemGreen
        addToListButton.backgroundColor = .systemGray2
        addToListButton.isEnabled = false
    }
}//end class

//
//  TrendingMediaCollectionViewCell.swift
//  uStream
//
//  Created by stanley phillips on 2/18/21.
//

import UIKit

public class TrendingMediaCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    var currentIndexPath: IndexPath? = nil
    
    // MARK: - Views
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemFill
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.cornerRadius = 8
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var posterImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
//    var subtitleLabel: UILabel = {
//        let label: UILabel = UILabel()
//        label.text = "Some subtitle"
//        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.container)
        self.container.addSubview(self.posterImageView)
//        self.container.addSubview(self.subtitleLabel)

        NSLayoutConstraint.activate([
            self.container.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.container.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.container.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.posterImageView.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 0),
            self.posterImageView.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: 0),
            self.posterImageView.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 0),
            self.posterImageView.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: 0)
        ])
        
//        NSLayoutConstraint.activate([
//            self.subtitleLabel.topAnchor.constraint(equalTo: self.posterImageView.bottomAnchor, constant: 10),
//            self.subtitleLabel.centerXAnchor.constraint(equalTo: self.posterImageView.centerXAnchor, constant: 0)
//        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    
    func setupCell(media: Media, indexPath: IndexPath) {
        self.currentIndexPath = indexPath
        TrendingMediaController.fetchPosterFor(media: media) { (result) in
            switch result {
            case .success(let image):
                    DispatchQueue.main.async {
                        if self.currentIndexPath == indexPath {
                            self.posterImageView.image = image
                            print("setImage")
                        } else {
                            print("threwout image")
                        }
                    }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }//end func
    
}//end class

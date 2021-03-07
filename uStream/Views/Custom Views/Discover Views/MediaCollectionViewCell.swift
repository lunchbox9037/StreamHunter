//
//  TrendingMediaCollectionViewCell.swift
//  uStream
//
//  Created by stanley phillips on 2/18/21.
//

import UIKit

public class MediaCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    var currentIndexPath: IndexPath? = nil
    
    // MARK: - Views
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemFill
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.cornerRadius = 8
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 32
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.container)
        self.container.addSubview(self.posterImageView)

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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    
    // MARK: - Methods
    func setupCell(media: Media, indexPath: IndexPath) {
        self.currentIndexPath = indexPath
        MediaController.fetchPosterFor(media: media) { (result) in
            switch result {
            case .success(let image):
                    DispatchQueue.main.async {
                        if self.currentIndexPath == indexPath {
                            self.posterImageView.image = image
                        }
                    }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }//end func
}//end class

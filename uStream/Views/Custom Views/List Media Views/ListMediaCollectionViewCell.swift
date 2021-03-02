//
//  ListMediaCollectionViewCell.swift
//  uStream
//
//  Created by stanley phillips on 2/28/21.
//

import UIKit

class ListMediaCollectionViewCell: UICollectionViewCell {
    var isAnimate: Bool! = true
    // MARK: - Views
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemFill
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var posterImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var removeBtn: UIButton = {
        let button: UIButton = UIButton()
        
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false

//        button.isHidden = true
        return button
    }()
    
    var subtitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Some subtitle"
        label.font = UIFont.preferredFont(forTextStyle: .footnote).withSize(8)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.container)
        
        self.container.addSubview(self.posterImageView)
        self.container.addSubview(self.removeBtn)
        
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
        
        NSLayoutConstraint.activate([
            self.removeBtn.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 0),
            self.removeBtn.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: 0)
        ])
        
        //        NSLayoutConstraint.activate([
        //            self.subtitleLabel.topAnchor.constraint(equalTo: self.posterImageView.bottomAnchor, constant: 10),
        //            self.subtitleLabel.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 0),
        //            self.subtitleLabel.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: 0),
        //            self.subtitleLabel.centerXAnchor.constraint(equalTo: self.posterImageView.centerXAnchor, constant: 0)
        //        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(media: ListMedia) {
        SearchResultsController.fetchPosterFor(media: media) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.posterImageView.image = image
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        subtitleLabel.text = media.title
    }
    
    //Animation of image
    func startAnimate() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.2
        shakeAnimation.repeatCount = 99999
        
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.timeOffset = 290 * drand48()
        
        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"animate")
        removeBtn.isHidden = false
        isAnimate = true
    }
    
    func stopAnimate() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "animate")
        self.removeBtn.isHidden = true
        isAnimate = false
    }
}//end class


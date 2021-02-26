//
//  SectionHeader.swift
//  uStream
//
//  Created by stanley phillips on 2/22/21.
//

import UIKit

public class SectionHeader: UICollectionViewCell {
//    var container: UIView = {
//        let view = UIView()
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.cornerRadius = 20
//        view.layer.shadowOpacity = 0.3
//        view.layer.shadowRadius = 10
//        view.layer.shadowOffset = CGSize(width: 0, height: 0)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Default"
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.titleLabel)
//        self.container.addSubview(self.titleLabel)
        
//        NSLayoutConstraint.activate([
//            self.container.topAnchor.constraint(equalTo: self.contentView.topAnchor),
//            self.container.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
//            self.container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
//            self.container.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
//        ])
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            self.titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12),
            self.titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(label: String) {
        titleLabel.text = label
    }
}//end class

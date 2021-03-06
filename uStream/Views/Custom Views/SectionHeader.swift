//
//  SectionHeader.swift
//  uStream
//
//  Created by stanley phillips on 2/22/21.
//

import UIKit

public class SectionHeader: UICollectionReusableView {
    var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Default"
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(20)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.lineBreakStrategy = .standard
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(label: String) {
        titleLabel.text = label
    }
}//end class

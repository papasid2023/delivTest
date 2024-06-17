//
//  customCellforPostsTableViewCell.swift
//  reminder
//
//  Created by Руслан Сидоренко on 21.05.2024.
//

import UIKit

class viewModel {
    let titlePost: String
    let imagePost: URL?
    var imageData: Data?
    
    init(titlePost: String, imagePost: URL?) {
        self.titlePost = titlePost
        self.imagePost = imagePost
    }
}

class customCellforPosts: UITableViewCell {
    
    static let identifier = "customCellforPosts"
   
    private let imagePost: UIImageView = {
        let imagePost = UIImageView()
        imagePost.contentMode = .scaleAspectFill
        imagePost.clipsToBounds = true
        imagePost.layer.cornerRadius = 10
        return imagePost
    }()
    
    private var titlePost: UILabel = {
        let titlePost = UILabel()
        titlePost.numberOfLines = 0
        titlePost.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return titlePost
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(imagePost)
        contentView.addSubview(titlePost)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imagePost.frame = CGRect(x: Int(separatorInset.left),
                                 y: 5,
                                 width: Int(contentView.frame.height-10),
                                 height: Int(contentView.frame.height-10))
        
        titlePost.frame = CGRect(x: Int(imagePost.frame.maxX)+5,
                                 y: 5,
                                 width: Int(contentView.frame.width-5-separatorInset.left - imagePost.frame.width),
                                 height: Int(contentView.frame.height)-10)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagePost.image = nil
        titlePost.text = nil
    }
    
    func configure(with viewModel: viewModel){
        titlePost.text = viewModel.titlePost
        
        if let data = viewModel.imageData {
            imagePost.image = UIImage(data: data)
        }
        else if let url = viewModel.imagePost {
            //fetch image and cache
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data = data else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.imagePost.image = UIImage(data: data)
                }
                
            }
            task.resume()
            
        }
        
    }
    
}



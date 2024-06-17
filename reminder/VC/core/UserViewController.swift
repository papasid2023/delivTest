//
//  UserViewController.swift
//  reminder
//
//  Created by Руслан Сидоренко on 14.05.2024.
//

import UIKit
import FirebaseAuth

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let helloLabel = UILabel()
    let currentEmail = Auth.auth().currentUser?.email ?? ""
    private var user: user?
    let avatarImageView = UIImageView(image: UIImage(systemName: "person.crop.circle.badge.plus"))
    private let makeNewPost = UIButton()
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupLogout()
        setupTableView()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    
    private func setupLogout(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign out", style: .done, target: self, action: #selector(didTapSignOut))
    }
    
    private func setupUI(){
        setupAvatar()
        
    }
    
    private func setupAvatar(
        avatar: String? = nil
    ){
        
       
        
        view.addSubview(avatarImageView)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.frame = CGRect(x: Int(view.frame.midX)-50,
                                       y: 150,
                                       width: 100,
                                       height: 100)
        
        let tapOnAvatar = UITapGestureRecognizer(target: self, action: #selector(didTapOnAvatar))
        avatarImageView.addGestureRecognizer(tapOnAvatar)
        
        
        
        //fetch image
        if let ref = avatar {
            
            let activity = UIActivityIndicatorView()
            view.addSubview(activity)
            activity.frame = CGRect(x: Int(view.frame.midX - 20), y: 50, width: 60, height: 60)
            activity.color = .gray
            activity.startAnimating()
            
            StorageManager.shared.downloadUrlForAvatar(path: ref) { url in
                guard let url = url else {
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.avatarImageView.image = UIImage(data: data)
                    }
                }
                task.resume()
                activity.stopAnimating()
            }
        }
        
    }
    
    func setupTableView(){
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(customCellforPosts.self,
                           forCellReuseIdentifier: customCellforPosts.identifier)
        fetchUserData()
    }
    
    
    private func fetchUserData(){
        
        print("Fetching user data")
        
        DatabaseManager.shared.getUser(email: currentEmail) { [weak self] user in
            guard let user = user else {
                return
            }
            
            self?.user = user
            
            print(user)
            
            DispatchQueue.main.async {
                self?.setupAvatar(
                    avatar: user.avatar)
            }
        }
        
    }
    
    @objc func didTapOnAvatar(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc func didTapSignOut(){
        AuthManager.shared.signOut { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print(error)
                return
            }
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
    
    //MARK: TableView for posts
    
    public var posts: [blogPost] = []
    
//    private func fetchPosts(){
//        print("Fetching posts...")
//        DatabaseManager.shared.getPosts(email: currentEmail) { [weak self] posts in
//            self?.posts = posts
//            print("Found \(posts.count) posts")
//            
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: customCellforPosts.identifier, for: indexPath) as? customCellforPosts else {
            fatalError()
        }
        cell.configure(with: .init(titlePost: post.titlePost,
                                   imagePost: post.imagePost))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}



extension UserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.editedImage] as? UIImage
        dismiss(animated: true, completion: nil)
        
        //upload avatar image
        StorageManager.shared.uploadAvatar(email: currentEmail, image: image) { 
            [weak self] success in
            guard let strongSelf = self else {
                return
            }
            print("upload image in storage...")
            if success {
                //update avatar
                DatabaseManager.shared.updateAvatar(email: strongSelf.currentEmail) { updated in
                    guard updated else {
                        return
                    }
                    
                    print("success upload url for image")
                    
                    DispatchQueue.main.async {
                        strongSelf.fetchUserData()
                    }
                    
                }
            }
            
        }
    }
}

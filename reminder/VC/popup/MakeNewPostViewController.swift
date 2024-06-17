////
////  MakeNewPostViewController.swift
////  reminder
////
////  Created by Руслан Сидоренко on 19.05.2024.
////
//
//import UIKit
//import FirebaseAuth
//
//class MakeNewPostViewController: UIViewController {
//
//    let currentEmail = Auth.auth().currentUser?.email ?? ""
//    var postPicture = UIImageView(image: UIImage(systemName: "photo.badge.plus.fill"))
//    private var selectedPostImage: UIImage?
//    let titleTextField = UITextField()
//    let postTextField = UITextField()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "make a new post"
//        view.backgroundColor = .white
//        setupNavItems()
//        setupUI()
//    }
//    
//   
//    
//    
//    
//    private func setupNavItems(){
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .done, target: self, action: #selector(didTapBack))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "post", style: .done, target: self, action: #selector(didTapPost))
//    }
//    
//    private func setupUI(){
//        
//        view.addSubview(postPicture)
//        postPicture.translatesAutoresizingMaskIntoConstraints = false
//        postPicture.contentMode = .scaleAspectFit
//        postPicture.isUserInteractionEnabled = true
//        
//        let tapOnPostPicture = UITapGestureRecognizer(target: self, action: #selector(didTapPostPicture))
//        postPicture.addGestureRecognizer(tapOnPostPicture)
//        
//        NSLayoutConstraint.activate([
//            postPicture.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            postPicture.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            postPicture.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            postPicture.heightAnchor.constraint(equalToConstant: 150)
//        ])
//        
//        
//        view.addSubview(titleTextField)
//        titleTextField.becomeFirstResponder()
//        titleTextField.translatesAutoresizingMaskIntoConstraints = false
//        titleTextField.placeholder = "Enter a title"
//        titleTextField.backgroundColor = .tertiaryLabel
//        titleTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
//        titleTextField.leftViewMode = .always
//        titleTextField.clipsToBounds = true
//        titleTextField.layer.cornerRadius = 10
//        
//        NSLayoutConstraint.activate([
//            titleTextField.topAnchor.constraint(equalTo: postPicture.bottomAnchor, constant: 20),
//            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
//            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
//            titleTextField.heightAnchor.constraint(equalToConstant: 40)
//        ])
//        
//        
//        view.addSubview(postTextField)
//        postTextField.translatesAutoresizingMaskIntoConstraints = false
//        postTextField.placeholder = "Enter a text post"
//        postTextField.backgroundColor = .tertiaryLabel
//        postTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
//        postTextField.leftViewMode = .always
//        postTextField.clipsToBounds = true
//        postTextField.layer.cornerRadius = 10
//        
//        NSLayoutConstraint.activate([
//            postTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
//            postTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
//            postTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
//            postTextField.heightAnchor.constraint(equalToConstant: 120)
//        ])
//    }
//    
//    @objc func didTapPostPicture(){
//        let imagePicker = UIImagePickerController()
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.allowsEditing = true
//        imagePicker.delegate = self
//        present(imagePicker, animated: true)
//    }
//    
//    @objc func didTapBack(){
//        dismiss(animated: true, completion: nil)
//    }
//    
//    @objc func cancelView(){
//        dismiss(animated: true, completion: nil)
//    }
//    
//    @objc func didTapPost(){
//        
//        
//        let activity = UIActivityIndicatorView()
//        view.addSubview(activity)
//        activity.frame = CGRect(x: Int(view.frame.midX - 20), y: 50, width: 60, height: 60)
//        activity.color = .gray
//        activity.startAnimating()
//        //check data
//        guard let titlePost = titleTextField.text,
//              let textPost = postTextField.text,
//              let imagePost = selectedPostImage else {
//                  
//                  let alert = UIAlertController(title: "Enter post details",
//                                                message: "Please enter a title, text and select an image",
//                                                preferredStyle: .alert)
//                  alert.addAction(UIAlertAction(title: "Dismiss",
//                                                style: .cancel,
//                                                handler: nil))
//                  present(alert, animated: true)
//            return
//        }
//        
//        print("Starting post...")
//        
//        let newPostId = UUID().uuidString
//        
//        //upload image for post
//        
//        StorageManager.shared.uploadPostImage(email: currentEmail,
//                                              image: imagePost,
//                                              postId: newPostId) { success in
//            guard success else {
//                return
//            }
//            
//            // download url for image for post
//            
//            StorageManager.shared.downloadUrlForPostImage(email: self.currentEmail, postId: newPostId) { url in
//                guard let postImageUrl = url else {
//                    print("Failed to download url for Header")
//                    return
//                }
//                
//                let dateFormatter = DateFormatter()
//                let date = Date()
//                dateFormatter.dateFormat = "dd MMMM yyyy hh:mm:ss"
//                dateFormatter.locale = Locale(identifier: "ru_RU")
//                let convertedDate: String = dateFormatter.string(from: date)
//                
//                let newPost = blogPost(identifier: newPostId,
//                                       titlePost: titlePost,
//                                       textPost: textPost,
//                                       imagePost: postImageUrl,
//                                       date: convertedDate)
//                
//                //inser new post in database
//                DatabaseManager.shared.insertPost(email: self.currentEmail,
//                                                  postId: newPostId,
//                                                  post: newPost) { [weak self] posted in
//                    guard posted else {
//                        return
//                    }
//                    
//                    DispatchQueue.main.async {
//                        self?.didTapBack()
//                    }
//                    
//                }
//                
//                
//            }
//            
//            
//        }
//        activity.stopAnimating()
//    }
//   
//    
//
//}
//
//extension MakeNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        dismiss(animated: true, completion: nil)
//        
//        guard let image = info[.editedImage] as? UIImage else {
//            return
//        }
//        
//        selectedPostImage = image
//        postPicture.image = image
//        
//    }
//    
//    
//}

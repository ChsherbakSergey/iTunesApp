//
//  ProfileViewController.swift
//  iTunesApp
//
//  Created by Sergey on 12/12/20.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - Views that will be displayed on this controller
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    //MARK: - Constants and Variables
    let models = ["Your E-mail Adress", "Your First Name and Last Name"]
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUI()
        setDelegates()
        setGestureRecognizerToImageView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //Frame of the profileImageView
        let size = view.width / 3
        profileImageView.frame = CGRect(x: (view.width - size) / 2, y: view.safeAreaInsets.top + 20, width: size, height: size)
        profileImageView.layer.cornerRadius = profileImageView.width / 2.0
        //Frame of the tableView
        tableView.frame = CGRect(x: 0, y: profileImageView.bottom + 20, width: view.width, height: 100)
    }
    
    //MARK: - Functions
    
    ///Configures Initial UI
    private func setInitialUI() {
        //Background color of the main view
        view.backgroundColor = .systemBackground
        //Adding subviews
        view.addSubview(tableView)
        view.addSubview(profileImageView)
    }
    
    ///Sets gesture recognizer
    private func setGestureRecognizerToImageView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfileImage))
        profileImageView.addGestureRecognizer(gesture)
    }
    
    ///Present photoActionSheet
    @objc private func didTapChangeProfileImage() {
        presentPhotoActionSheet()
    }
    
    ///Configures Delegates
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

}


//MARK: - UITableViewDelegate and UITableViewDataSource Implementation

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .label
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

//MARK: - UIImagePickerControllerDelegate and UINavigationControllerDelegate Implementation

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        profileImageView.image = selectedImage
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

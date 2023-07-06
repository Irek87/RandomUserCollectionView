//
//  MainViewController.swift
//  RandomUserCollectionView
//
//  Created by Reek i on 05.07.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private var numberOfUsers = 0
    private var users: [User] = []
    private var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        showInitAlert()
        setupRefreshControl()
        activityIndicator.isHidden = true
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        showInitAlert()
    }

    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         guard let detailsVC = segue.destination as? DetailsViewController else { return }
         detailsVC.user = sender as? User
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        user = users[indexPath.row]
        performSegue(withIdentifier: "showDetails", sender: user)
    }
    
    
    // MARK: showInitAlert
    private func showInitAlert() {
        let alert = UIAlertController(title: "Hello!", message: "How much users would You like to see?", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = .numberPad
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let numOfUsers = Int(alert.textFields?.first?.text ?? "") {
                self.numberOfUsers = numOfUsers
                self.downloadData()
            } else {
                self.showInitAlert()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    // MARK: downloadData
    private func downloadData() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        NetworkManager.shared.delegate = self
        NetworkManager.shared.getUsers(numberOfUsers: numberOfUsers) { result in
            self.users = result.results
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.collectionView.reloadData()
        }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserCollectionViewCell
        
        let userImageURL = users[indexPath.row].picture.large
        NetworkManager.shared.getUserImage(from: userImageURL) { image in
            cell.imageView.image = image
        }
        
        cell.layer.cornerRadius = cell.layer.frame.width/2
        return cell
    }
}



// MARK: UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
        if view.frame.width < view.frame.height {
            return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width/3-3,
                          height: view.safeAreaLayoutGuide.layoutFrame.width/3-3)
        } else {
            return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width/5-3,
                          height: view.safeAreaLayoutGuide.layoutFrame.width/5-3)
        }
    }
    
}

// MARK: NetworkManagerDelegateProtocol
extension MainViewController: NetworkManagerDelegateProtocol {
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Something is wrong. Check your internet connection", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: SetupRefreshControl
extension MainViewController {
    private func setupRefreshControl() {
        self.collectionView.refreshControl = UIRefreshControl()
        self.collectionView.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.collectionView.refreshControl?.addTarget(self, action: #selector(updateView), for: .valueChanged)
        self.collectionView.addSubview(self.collectionView.refreshControl ?? UIRefreshControl())
    }
    
    @objc private func updateView() {
        NetworkManager.shared.getUsers(numberOfUsers: numberOfUsers) { result in
            self.users = result.results
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
}

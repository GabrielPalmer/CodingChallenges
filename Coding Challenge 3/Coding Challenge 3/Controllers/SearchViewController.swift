//
//  ViewController.swift
//  Coding Challenge 3
//
//  Created by Gabriel Blaine Palmer on 5/20/19.
//  Copyright © 2019 Gabriel Blaine Palmer. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [Movie] = []
    var selectedMediaType: MediaType = .movie
    
    override func viewDidLoad() {
        
        MoviesController.shared.loadFavoriteMovies()
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    @IBAction func mediaTypeControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedMediaType = .movie
        case 1:
            selectedMediaType = .series
        case 2:
            selectedMediaType = .episode
        case 3:
            selectedMediaType = .game
        default:
            print("Unrecognized index on media type control")
        }
    }
    
    //===========================================
    // MARK: - Table View Delegate
    //===========================================
    
    func imageForMovie(_ movie: Movie, completion: @escaping (UIImage?) -> Void) {
        
        guard let url = URL(string: movie.imageURL) else {
            return
        }
        
        NetworkController.fetchData(from: url) { (data) in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        let movie = movies[indexPath.row]
        
        cell.titleLabel.text = "\(movie.title) (\(movie.year))"
        
        imageForMovie(movie) { (image) in
            cell.posterImageView.image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertController = UIAlertController(
            title: "Add \(movies[indexPath.row].title) to favorites",
            message: nil,
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(
            title: "Yes",
            style: .default,
            handler: { (_) in
                MoviesController.shared.favorites.append(self.movies[indexPath.row])
                MoviesController.shared.saveFavoriteMovies()
                
                if let favoritesTVC = self.tabBarController?.viewControllers?.last as? FavoritesTableViewController {
                    favoritesTVC.loadViewIfNeeded()
                    favoritesTVC.tableView.reloadData()
                }
        }))
        
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: { (_) in
                self.tableView.deselectRow(at: indexPath, animated: true)
        }))
        
        present(alertController, animated: true)
    }
    
    //===========================================
    // MARK: - Search Bar Delegate
    //===========================================
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        
        MoviesController.shared.fetchMedia(searchTerm: searchTerm, type: selectedMediaType) { (movies) in
            DispatchQueue.main.async {
                self.movies = movies
                self.tableView.reloadData()
            }
            
        }
    }

}


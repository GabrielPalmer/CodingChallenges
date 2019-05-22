//
//  FavoritesTableViewController.swift
//  Coding Challenge 3
//
//  Created by Gabriel Blaine Palmer on 5/20/19.
//  Copyright © 2019 Gabriel Blaine Palmer. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {

    //===========================================
    // MARK: - Table View Data Source
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MoviesController.shared.favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        let movie = MoviesController.shared.favorites[indexPath.row]
        
        cell.titleLabel.text = "\(movie.title) (\(movie.year))"
        imageForMovie(movie) { (image) in
            cell.posterImageView.image = image
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MoviesController.shared.favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            MoviesController.shared.saveFavoriteMovies()
        }
    }

}

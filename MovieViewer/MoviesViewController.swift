//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Olivia Koshy on 6/15/16.
//  Copyright © 2016 Olivia Koshy. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class MoviesViewController: UIViewController, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    var movies: [NSDictionary]?
    var refreshControl = UIRefreshControl()
    var filteredData: [NSDictionary]!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        filteredData = movies
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
        
        
        
        let apiKey = "40b56d465d7ccfb7f58655052fce9189"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data, options:[]) as? NSDictionary {
                    print("response: \(responseDictionary)")
                    
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.filteredData = self.movies
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                   
                }
               
            }
        })
        task.resume()
        

        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filteredData = filteredData {
            return filteredData.count
        }else {
            return 0
        }
        
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieViewCell
        
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        let posterPath = movie["poster_path"] as! String
        
        
        let baseURL = "http://image.tmdb.org/t/p/w500"
        
        let imageURL = NSURL(string: baseURL + posterPath)
        
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterView.setImageWithURL(imageURL!)
        
        
        print("row\(indexPath.row)")
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let filteredData = filteredData {
//            print(movies.count)
            return filteredData.count
        }else {
//            print(0)
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PosterCell", forIndexPath: indexPath) as! PosterCell
        
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        let posterPath = movie["poster_path"] as! String
        
        
        let baseURL = "http://image.tmdb.org/t/p/w500"
        
        let imageURL = NSURL(string: baseURL + posterPath)
        
        
        cell.titleLabel.text = title
        //cell.titleLabel.text = overview
        print("rendering")
        cell.pictureView.setImageWithURL(imageURL!)
        
        
        print("row\(indexPath.row)")
        return cell
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredData = movies
        } else {
        filteredData = movies!.filter({(dataString: NSDictionary) -> Bool in
            let title = dataString["title"] as! String

            return title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        tableView.reloadData()
        collectionView.reloadData()
        }
    }

    
    func loadDataFromNetwork(refreshControl: UIRefreshControl) {
        
        let apiKey = "40b56d465d7ccfb7f58655052fce9189"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        
        let myRequest = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest,                                                completionHandler: { (data, response, error) in
            
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            // ... Remainder of response handling code ...
            
        });
        task.resume()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        let apiKey = "40b56d465d7ccfb7f58655052fce9189"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let myRequest = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest,completionHandler: { (data, response, error) in
            
            // ... Use the new data to update the data source ...
            
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        });
        task.resume()
    }
    
    
    
   
  
    
 
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

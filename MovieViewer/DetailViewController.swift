//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Olivia Koshy on 6/17/16.
//  Copyright © 2016 Olivia Koshy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var OverviewLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var movie: NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(movie)
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        if let posterPath = movie["poster_path"] as? String {
        let baseURL = "http://image.tmdb.org/t/p/w500"
        let imageURL = NSURL(string: baseURL + posterPath)
        posterImage.setImageWithURL(imageURL!)
        
    
        }
        titleLabel.text = title
        OverviewLabel.text = overview
        //posterImage.setImageWithURL(imageURL)
        
        
        
        
        
        
        
    
        
      
        
   

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

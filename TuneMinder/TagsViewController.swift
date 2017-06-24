//
//  TagsViewController.swift
//  TuneMinder
//
//  Created by Omri Gazitt on 6/4/17.
//  Copyright © 2017 Omri Gazitt. All rights reserved.
//

import UIKit
import CoreData

class TagsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tags: [Tag] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        do {
            tags = try context.fetch(Tag.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDataSource
extension TagsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath)
            //cell.textLabel?.text = tags[indexPath.row].url
            let artist = tags[indexPath.row].artist ?? ""
            let track = tags[indexPath.row].track ?? ""
            let cellTitle = artist == "" ? tags[indexPath.row].url : "\(artist):\(track)"
            cell.textLabel?.text = cellTitle
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User tapped " + String(indexPath.row))
        
        //let imagePath = tags[indexPath.row].url
        
        self.performSegue(withIdentifier: "detailSegue", sender:self)

        //let detail = DetailViewController()
        //detail.imagePath = imagePath!
        //present(detail, animated: true, completion:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" ,
            let nextScene = segue.destination as? DetailViewController ,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let imagePath = tags[indexPath.row].url
            nextScene.imagePath = imagePath!
        }
    }
}

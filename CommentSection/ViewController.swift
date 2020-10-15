//
//  ViewController.swift
//  CommentSection
//
//  Created by Gayathri on 14/10/20.
//  Copyright © 2020 Gayathri. All rights reserved.
//

import UIKit

// MARK: - UITableViewCell Class

class HeaderTableViewCell: UITableViewCell {
  
    @IBOutlet weak var replyLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    var index:Int = 0
    var section:Int = 0
  
}

// MARK: - HeaderView Class

class HeaderView: UITableViewHeaderFooterView {
    
    var nameLabel = UILabel()
    var commentLabel = UILabel()
    var viewMoreLabel = UILabel()

    
    static let reuseIdentifier: String = String(describing: self)

}

// MARK: - ViewController Class

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    
  @IBOutlet weak var CommentsTableView: UITableView!
    var sectionArr = [Any]()
    var sections = [String]()
    var listDic = [String : Any]()
    var selectedIndex: Int = -1
    var index:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting header with tableview
        
        self.CommentsTableView.register(HeaderView.self,forHeaderFooterViewReuseIdentifier:HeaderView.reuseIdentifier)
        
       // getting the datas from the json file
        
        do {
            if let file = Bundle.main.url(forResource: "sample", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? Dictionary<String, AnyObject> {
                    listDic = object
                    // json is a dictionary
                    print(object)
                    let person = object["Comments"] as? [[String : Any]]
                    
                    for i in 0...person!.count - 1
                    {
                        let personObject = person![i] as [String : Any]
                        sections.append(personObject["Name"] as! String)
                    }
                                      
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        
                

    }
    
// MARK: - UITableView Delegates and Datasources

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (listDic.count != 0)
       {
        let person = listDic["Comments"] as? [[String : Any]]
        let personObject = person![section] as [String : Any]
        let replies = personObject["Replies"] as! [[String : Any]]
        print("replies====",replies.count)
        return replies.count
        
        }
       else{
        return 1
        }
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell : HeaderTableViewCell = CommentsTableView.dequeueReusableCell(withIdentifier: "RepliesCell", for: indexPath) as! HeaderTableViewCell
          
        let person = listDic["Comments"] as? [[String : Any]]
        let personObject = person![indexPath.section] as [String : Any]
        let replies = personObject["Replies"] as! [[String : Any]]
        let replyObject = replies[indexPath.row]
        cell.nameLbl.text = replyObject["name"] as? String
        cell.replyLbl.text = replyObject["reply"] as? String

           return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return sections.count;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           
           guard let header = CommentsTableView.dequeueReusableHeaderFooterView(
                               withIdentifier: HeaderView.reuseIdentifier)
                               as? HeaderView
           else {
               return nil
           }
           
        header.tag = section
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.handleTap(_:)))
        
        tap.delegate = self
        header.addGestureRecognizer(tap)
  
        
           header.nameLabel = UILabel(frame: CGRect(x: 5, y: 0, width: tableView.frame.size.width, height: 30))
           header.nameLabel.text = sections[section]
        header.nameLabel.textAlignment = .left
        header.nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
           header.addSubview(header.nameLabel)

        header.commentLabel = UILabel(frame: CGRect(x:10, y: 0, width: tableView.frame.size.width-10, height: 100))
        header.commentLabel.textAlignment = .left
        header.commentLabel.numberOfLines = 0
        header.commentLabel.font = UIFont.systemFont(ofSize: 13)
           let person = listDic["Comments"] as? [[String : Any]]
           let personObject = person![section] as [String : Any]
        header.commentLabel.text = personObject["Message"] as? String
           header.addSubview(header.commentLabel)
        
        header.viewMoreLabel = UILabel(frame: CGRect(x:tableView.frame.size.width-80, y: 60, width: 80, height: 20))
        header.viewMoreLabel.text = "ViewReplies.."
        header.viewMoreLabel.textAlignment = .left
        header.viewMoreLabel.font = UIFont.boldSystemFont(ofSize: 11)
        header.addSubview(header.viewMoreLabel)
           return header
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(selectedIndex == indexPath.section)
        {
            return 100
        }
        else{
        return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
   
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        index = (sender.view?.tag)!
        
            if (selectedIndex == index) {
                       // it was already selected
                selectedIndex = -1
                CommentsTableView.reloadSections(IndexSet(integer: sender.view!.tag), with: .automatic)
            }
            else{
                selectedIndex = index
                CommentsTableView.reloadSections(IndexSet(integer: sender.view!.tag), with: .automatic)
            }
        
    }
}


//
//  CategoryViewController.swift
//  tpnote
//
//  Created by user226973 on 2/13/23.
//

import UIKit

class CategoryViewController: UITableViewController {
    var token:Token?
    var categories:Categories?
    var dataSource = [Category]()
    
    var selectedCategory:Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.dataSource.append(Category(key: SelfClass(href: ""), name: "Move screen to show...", id: -1))
        self.getToken()
    }

    // MARK: - Table view data source
    
    func getToken(){
        //creation basic auth pour header
        let username = "07690dba3c95489995015e9e831bcb87"
        let password = "2zhq486qlSm28w8i5xCKkRS12FJv0jjI"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        var url = URLComponents(string: "https://oauth.battle.net/token")!
        //ajout grant_type dans params
        url.queryItems = [
            URLQueryItem(name: "grant_type", value: "client_credentials")
        ]
        var request = URLRequest(url: url.url!)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        

        // fire off the request
        // make sure your class conforms to NSURLConnectionDelegate
    
        let task = URLSession.shared.dataTask(with: request){
            (data,resp,err) in
            if let err = err{
                print("An error occured: ",err)
                return
            }
            guard let data = data else{return}
            guard let token = try? JSONDecoder().decode(Token.self, from: data)
            else {return}
            self.token = token
            //si token reçu avec succès, on recupère les categories
            self.getCategories()
            
        }
        task.resume()
    }
    
    func getCategories(){
        // create the request
        var url = URLComponents(string: "https://us.api.blizzard.com/data/wow/achievement-category/index")!
        //on met en params l'access_token qu'on a eu de la rêquete precedente
        url.queryItems = [
            URLQueryItem(name: "access_token", value: token!.accessToken),
            URLQueryItem(name: "namespace", value: "static-us"),
            URLQueryItem(name: "locale", value: "en_US")
        ]
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
    
        let task = URLSession.shared.dataTask(with: request){
            (data,resp,err) in
            if let err = err{
                print("An error occured: ",err)
                return
            }
            guard let data = data else{return}
            guard let categories = try? JSONDecoder().decode(Categories.self, from: data)
            else {return}
            self.dataSource = categories.categories
            self.tableView.reloadData()
            
        }
        task.resume()
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = self.dataSource[indexPath.row].name
        cell.largeContentTitle = self.dataSource[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Stocker dans la variable d'instance, le post choisi
        self.selectedCategory = self.dataSource[indexPath.row]
        performSegue(withIdentifier: "categorySegue", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "categorySegue":
            let destination=segue.destination as! AchievementViewController
            destination.token = self.token
            destination.id = selectedCategory!.id
        default:
            print("mauvais segue")
        }
    }
    

}

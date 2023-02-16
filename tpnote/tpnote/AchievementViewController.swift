import UIKit

class AchievementViewController: UITableViewController {
    var token:Token?
    var id:Int = 0
    
    var achievements:Achievements?
    var dataSource = [Achievement]()
    var selectedAchievement:Achievement?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.dataSource.append(Achievement(key: SelfClass(href: ""), name: "Request error", id: -1))
        self.getAchievements()
    }

    // MARK: - Table view data source
    
    func getAchievements(){
        // create the request
        var url = URLComponents(string: "https://us.api.blizzard.com/data/wow/achievement-category/\(self.id)")!
        url.queryItems = [
            URLQueryItem(name: "access_token", value: token!.accessToken),
            URLQueryItem(name: "namespace", value: "static-us"),
            URLQueryItem(name: "locale", value: "en_US")
        ]
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        


        // fire off the request
        // make sure your class conforms to NSURLConnectionDelegate
    
        let task = URLSession.shared.dataTask(with: request){
            (data,resp,err) in
            if let err = err{
                print("An error occured: ",err)
                return
            }
            guard let data = data else{return}
            guard let achievements = try? JSONDecoder().decode(Achievements.self, from: data)
            else {return}
            self.dataSource = achievements.achievements
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "achievementCell", for: indexPath)
        cell.textLabel?.text = self.dataSource[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Stocker dans la variable d'instance, le post choisi
        self.selectedAchievement = self.dataSource[indexPath.row]
        performSegue(withIdentifier: "achievementSegue", sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "achievementSegue":
            let destination=segue.destination as! AchievementDetailViewController
            destination.token = self.token
            destination.id = selectedAchievement!.id
        default:
            print("mauvais segue")
        }
        
    }
}

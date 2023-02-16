
import UIKit

class AchievementDetailViewController: UIViewController {
    var token:Token?
    var id:Int = 0

    @IBOutlet weak var descriptionAchievement: UITextView!
    @IBOutlet weak var titleAchievement: UILabel!
    var achievement:AchievementDetail?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getAchievementDetail()
    }
    
    func getAchievementDetail(){
        // create the request
        var url = URLComponents(string: "https://us.api.blizzard.com/data/wow/achievement/\(self.id)")!
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
            guard let achievement = try? JSONDecoder().decode(AchievementDetail.self, from: data)
            else {return}
            self.titleAchievement.text = achievement.name
            self.descriptionAchievement.text = achievement.description
        }
        task.resume()
    }
    


}

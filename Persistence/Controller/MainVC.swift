import UIKit
import CoreData

class MainVC: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func studentRole(_ sender: UIButton) {
        self.performSegue(withIdentifier: "studentSegue", sender: self)
    }
    
    
    @IBAction func teacherRole(_ sender: UIButton) {
        self.performSegue(withIdentifier: "teacherSegue", sender: self)
    }
}

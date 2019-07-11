import UIKit

class StudentReviewVC: UIViewController {
    
    @IBOutlet weak var stIdLbl: UILabel!
    @IBOutlet weak var numCoursesLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stIdLbl.text = activeStudentId
        numCoursesLbl.text = "Number of courses: " + String(studentDao?.getStudent(withStId: activeStudentId)?.takesCourses?.count ?? 0)
    }
}

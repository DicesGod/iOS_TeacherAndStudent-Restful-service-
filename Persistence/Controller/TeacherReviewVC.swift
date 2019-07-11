import UIKit

class TeacherReviewVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var numCoursesLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = activeTeacherId
        numCoursesLbl.text = "Number of courses: " + String(teacherDao?.getTeacher(withTId: activeTeacherId)?.teachesCourses?.count ?? 0)
    }
}

import UIKit

class StudentTakeCourseVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var coursesTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coursesTV.delegate = self
        coursesTV.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseDao!.getAllCourses()!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let allCourses = courseDao!.getAllCourses()!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "studentTakeCourseCell") as? StudentTakeCourseCell {
            cell.idLbl.text = allCourses[indexPath.row].csId
            cell.titleLbl.text = allCourses[indexPath.row].title
            cell.creditLbl.text = String(allCourses[indexPath.row].credit)
            cell.teacherLbl.text = allCourses[indexPath.row].taughtByTeacher?.name
            cell.semesterLbl.text = allCourses[indexPath.row].semester
            cell.gpaLabel.text = "Comming Soon"
            return cell
        } else {
            return StudentTakeCourseCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let allCourses = courseDao!.getAllCourses()!
        let activeStudent = studentDao!.getStudent(withStId: activeStudentId)
        if studentDao!.assignCourse(withCsId: allCourses[indexPath.row].csId!, toStudent: activeStudent!) {
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.popViewController(animated: true)
            let tvc = (self.navigationController?.topViewController as? StudentCoursesTVC)
            tvc?.allCourses.removeAll()
            if let allCoursesSet = studentDao!.getStudent(withStId: activeStudentId)?.takesCourses {
                for cs in allCoursesSet {
                    tvc?.allCourses.append(cs as! Course)
                }
            }
            tvc?.tableView.reloadData()
            return
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.popViewController(animated: true)
            return
        }
    }
}

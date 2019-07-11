import UIKit

class TeacherCoursesTVC: UITableViewController {
    
    var allCourses = [Course]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        allCourses.removeAll()
        if let allCoursesSet = teacherDao!.getTeacher(withTId: activeTeacherId)?.teachesCourses {
            for cs in allCoursesSet {
                allCourses.append(cs as! Course)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCourses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "teacherCourseCell") as? TeacherCourseCell {
            cell.idLbl.text = allCourses[indexPath.row].csId
            cell.titleLbl.text = allCourses[indexPath.row].title
            cell.creditLbl.text = String(allCourses[indexPath.row].credit)
            cell.teacherLbl.text = allCourses[indexPath.row].taughtByTeacher?.name
            cell.semesterLbl.text = allCourses[indexPath.row].semester
            cell.gpaLabel.text = "Comming Soon"
            return cell
        } else {
            return TeacherCourseCell()
        }
    }
}

import UIKit

class StudentCoursesTVC: UITableViewController {
    
    var allCourses = [Course]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        allCourses.removeAll()
        if let allCoursesSet = studentDao!.getStudent(withStId: activeStudentId)?.takesCourses {
            for cs in allCoursesSet {
                allCourses.append(cs as! Course)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCourses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "studentCourseCell") as? StudentCourseCell {
            cell.idLbl.text = allCourses[indexPath.row].csId
            cell.titleLbl.text = allCourses[indexPath.row].title
            cell.creditLbl.text = String(allCourses[indexPath.row].credit)
            cell.teacherLbl.text = allCourses[indexPath.row].taughtByTeacher?.name
            cell.semesterLbl.text = allCourses[indexPath.row].semester
            cell.gpaLabel.text = "Comming Soon"
            return cell
        } else {
            return StudentCourseCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let remove = UITableViewRowAction(style: .destructive, title: "Drop") {action, index in
            if studentDao!.removeCourse(withCsId: self.allCourses[index.row].csId!, forStudent: studentDao!.getStudent(withStId: activeStudentId)!) {
                self.allCourses.removeAll()
                if let allCoursesSet = studentDao!.getStudent(withStId: activeStudentId)?.takesCourses {
                    for cs in allCoursesSet {
                        self.allCourses.append(cs as! Course)
                    }
                }
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
//                self.tableView.reloadData()
            }
        }
        remove.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        return [remove]
    }
}

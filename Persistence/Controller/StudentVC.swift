import UIKit

class StudentVC: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var semesterTF: UITextField!
    @IBOutlet weak var rPasswordTF: UITextField!
    
    @IBOutlet weak var stIdTF: UITextField!
    @IBOutlet weak var lPasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerStudent(_ sender: Any) {
        let count = studentDao?.getAllStudents()!.count
        let name = nameTF.text!
        // 2019 Winter
        let semester = semesterTF.text!.split(separator: " ")
        if semester.count < 2 {
            return
        }
        let password = rPasswordTF.text!
        let year = Int(semester.first!)
        let sem = semester.last!.first.map { (ch) -> Int in
            switch (ch) {
                case "W":
                    return 0
                case "S":
                    return 1
                case "F":
                    return 2
                default:
                    return 9
            }
        }
        let stId = "ST\(year! % 100)\(sem!)\(count! + 1)"
        let studentForm = StudentForm(name: name, semester: semesterTF.text!, password: password, stId: stId)
        if !studentDao!.saveStudent(withStudentForm: studentForm) {
            nameTF.text = "Unable to save the student!"
        } else {
            activeStudentId = stId
            performSegue(withIdentifier: "studentSignon", sender: self)
        }
    }
    
    @IBAction func loginStudent(_ sender: Any) {
        let stId = stIdTF.text!
        let password = lPasswordTF.text!
        if let student = studentDao?.getStudent(withStId: stId) {
            if student.password == password {
                activeStudentId = stId
                performSegue(withIdentifier: "studentSignon", sender: self)
            } else {
                lPasswordTF.text = "Wrong password!"
            }
        } else {
            stIdTF.text = "Student does not exist!"
        }
    }
}

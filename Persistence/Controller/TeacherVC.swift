import UIKit

class TeacherVC: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var rPasswordTF: UITextField!
    
    @IBOutlet weak var tIdTF: UITextField!
    @IBOutlet weak var lPasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func teacherRegisterBtn(_ sender: UIButton) {
        let count = teacherDao?.getAllTeachers()?.count
        let name = nameTF.text!
        let tId = "T\(count! + 1)"
        let password = rPasswordTF.text!
        let teacherForm = TeacherForm(name: name, password: password, tId: tId)
        if !teacherDao!.saveTeacher(withTeacherForm: teacherForm) {
            nameTF.text = "Unable to save the teacher!"
        } else {
            activeTeacherId = tId
            performSegue(withIdentifier: "teacherSignon", sender: self)
        }
    }
    
    @IBAction func teacherLoginBtn(_ sender: UIButton) {
        let tId = tIdTF.text!
        let password = lPasswordTF.text!
        if let teacher = teacherDao?.getTeacher(withTId: tId) {
            if teacher.password == password {
                activeTeacherId = tId
                performSegue(withIdentifier: "teacherSignon", sender: self)
            } else {
                lPasswordTF.text = "Wrong password!"
            }
        } else {
            tIdTF.text = "Teacher does not exist!"
        }
    }
}

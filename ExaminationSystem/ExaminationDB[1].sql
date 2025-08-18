--******************** CREATE DATABASE ************************************
CREATE DATABASE ExaminationDB;
go 
USE ExaminationDB;
--******************** CREATE SCHEMAS *************************************
--auth, academic, exams
CREATE SCHEMA auth;
GO
CREATE SCHEMA academic;
GO
CREATE SCHEMA exams;

--******************* CREATE TABLES ****************************************
--1.USERS table
CREATE TABLE auth.USERS
(
userId INT IDENTITY(1,1) PRIMARY KEY,
Fname VARCHAR(20) NOT NULL,
Lname VARCHAR(20) NOT NULL,
Email VARCHAR(255) UNIQUE,
Password VARCHAR(255) CHECK (LEN(password)>=8) NOT NULL,
Role VARCHAR(255),
roleID INT,
lastLogin DATE DEFAULT GETDATE()

);
go
--2.STUDENTS table
CREATE TABLE auth.STUDENTS
(
studentID INT PRIMARY KEY,
personalInfo VARCHAR(255),
Status VARCHAR(255)
);
go
--3.INSTRUCTORS table
CREATE TABLE auth.INSTRUCTORS
(
instructorId INT PRIMARY KEY,
Specilization VARCHAR(255),
Qualifications VARCHAR(255),
yearsOfExperience INT
);
go
--4.MANGER table
CREATE TABLE auth.training_manager
(
managerId INT PRIMARY KEY
);
go
--5.BRANCHES table
CREATE TABLE academic.BRANCHES
(
branchId INT PRIMARY KEY,
Name VARCHAR(255),
Description VARCHAR(255)
);
go
--6.INTAKES table
CREATE TABLE academic.INTAKES 
(
IntakeID INT PRIMARY KEY,
StartDate DATE,
EndDATE DATE,
TrackID INT 
);
go
--7.TRACKS table
CREATE TABLE academic.TRACKS
(
TrackID INT PRIMARY KEY,
Name VARCHAR(255),
Description VARCHAR(255),
BranchID INT
);
go
--8.COURSES table
CREATE TABLE academic.COURSES
(
CourseID INT PRIMARY KEY,
Name VARCHAR(255),
Description VARCHAR(255),
MaxDegree INT,
MinDegree INT,
mng_id INT,
intake_id INT
);
go
--9.instr_intake_course table
CREATE TABLE academic.instr_intake_course
(
instructor_id INT,
intake_id INT,
course_id INT,
HireDate DATE,
PRIMARY KEY(instructor_id,intake_id, course_id)
);
go

--10.QUESTIONS table
CREATE TABLE exams.QUESTIONS
(
QuestionID INT PRIMARY KEY,
Content VARCHAR(255),
Type VARCHAR(255),
Points INT,
CorrectAnswer VARCHAR(255),
BestAcceptedAnswer VARCHAR(255),
ExamID INT
);
go
--11.Student_Answers table
CREATE TABLE exams.student_answer
(
StudentAnswerID INT PRIMARY KEY,
student_id INT,
question_id INT,
answer_option_id INT,
TextAnswer varchar(255),
points INT 
);
go
--12.answer_options table
CREATE TABLE exams.answer_options
(
AnswerOptionID INT PRIMARY KEY,
Content VARCHAR(225),
IsCorrect CHAR(1),
question_id INT
);
go
--13.EXAMS table
CREATE TABLE exams.EXAMS
(
ExamID INT PRIMARY KEY,
StartTime DATETIME,
EndTime DATETIME,
TotalPoints INT,
Type VARCHAR(30) DEFAULT 'exam',
course_id INT,
instructor_id INT
);
go
--14.exam_questions table
CREATE TABLE exams.exam_questions
(ExamID INT,
QuestionID INT,
PRIMARY KEY(ExamID, QuestionID)
);
go
--15. ROLES table
CREATE TABLE auth.ROLES (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) UNIQUE NOT NULL, --  Admin, Instructor, Student
    Description NVARCHAR(255)
);
--16.PERMISSIONS table
CREATE TABLE auth.PERMISSIONS (
    PermissionID INT IDENTITY(1,1) PRIMARY KEY,
    PermissionName NVARCHAR(100) UNIQUE NOT NULL, -- Manage Exams, View Grades
    Description NVARCHAR(255)
);
--17.role_permissions table
CREATE TABLE auth.ROLE_PERMISSIONS (
    RoleID INT NOT NULL,
    PermissionID INT NOT NULL,
    PRIMARY KEY (RoleID, PermissionID),
    FOREIGN KEY (RoleID) REFERENCES auth.ROLES(RoleID) ON DELETE CASCADE,
    FOREIGN KEY (PermissionID) REFERENCES auth.PERMISSIONS(PermissionID) ON DELETE CASCADE
);
go
--18.exams.student_answer_audit table
CREATE TABLE exams.student_answer_audit
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    StudentAnswerID INT,
    OldAnswerOptionID INT,
    NewAnswerOptionID INT,
    OldTextAnswer VARCHAR(255),
    NewTextAnswer VARCHAR(255),
    ChangedAt DATETIME DEFAULT GETDATE()
);
--19. USER LOG Table
CREATE TABLE auth.UserLog (
    LogID INT IDENTITY(1,1),
    UserName VARCHAR(255),
    ActionType VARCHAR(50),
    ActionDate DATETIME,
    ChangedBy VARCHAR(255)
);

--********************* ADDING GOREIGN KEY CONSTRAINT TO TABLES *************************************
--1.USER Table
ALTER TABLE auth.USERS
ADD CONSTRAINT User_FK FOREIGN KEY(roleID) REFERENCES auth.ROLES (RoleID)
ON DELETE CASCADE ON UPDATE CASCADE;
--2.STUDENTS table
ALTER TABLE auth.STUDENTS
ADD CONSTRAINT student_FK FOREIGN KEY(StudentID) REFERENCES auth.USERS(UserID)
ON DELETE CASCADE ON UPDATE CASCADE;
--3.INSTRUCTORS table
ALTER TABLE auth.INSTRUCTORS
ADD CONSTRAINT instructor_FK FOREIGN KEY(InstructorID) REFERENCES auth.USERS(UserID)
ON DELETE CASCADE ON UPDATE CASCADE;
--4.MANGER table
ALTER TABLE auth.training_manager
ADD CONSTRAINT manager_FK FOREIGN KEY(ManagerID) REFERENCES auth.USERS(UserID)
ON DELETE CASCADE ON UPDATE CASCADE;
--5.INTAKES table
ALTER TABLE academic.INTAKES
ADD CONSTRAINT intake_FK FOREIGN KEY (TrackID) REFERENCES [academic].[TRACKS](TrackID)
ON DELETE SET NULL ON UPDATE CASCADE;

--6.TRACKS table
ALTER TABLE academic.TRACKS
ADD CONSTRAINT track_FK FOREIGN KEY([BranchID]) REFERENCES [academic].[BRANCHES](branchId)
ON DELETE SET NULL ON UPDATE CASCADE;

--7.COURSES table
ALTER TABLE [academic].[COURSES]
ADD CONSTRAINT track_FK1 FOREIGN KEY([intake_id]) REFERENCES[academic].[INTAKES](IntakeID)
    ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT track_FK2 FOREIGN KEY([mng_id]) REFERENCES[auth].[training_manager](managerId)
    ON DELETE SET NULL ON UPDATE CASCADE;
--8. Questions table 
ALTER TABLE [exams].[QUESTIONS]
ADD CONSTRAINT qu_FK FOREIGN KEY([ExamID]) REFERENCES [exams].[EXAMS]([ExamID])

--9.instr_intake_course table
ALTER TABLE [academic].[instr_intake_course]
ADD CONSTRAINT FK11 FOREIGN KEY([course_id]) REFERENCES[academic].[COURSES]([CourseID])
    ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT FK22 FOREIGN KEY([instructor_id]) REFERENCES[auth].[INSTRUCTORS]([instructorId])
        ON DELETE NO ACTION ON UPDATE NO ACTION,

    CONSTRAINT FK33 FOREIGN KEY([intake_id]) REFERENCES[academic].[INTAKES]([IntakeID])
        ON DELETE NO ACTION ON UPDATE NO ACTION;

--10.Student_Answers table
ALTER TABLE [exams].[student_answer]
ADD CONSTRAINT Student_Answer_FK1 FOREIGN KEY([student_id]) REFERENCES[auth].[STUDENTS]([studentID])
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Student_Answer_FK2 FOREIGN KEY([question_id]) REFERENCES[exams].[QUESTIONS]([QuestionID])
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT Student_Answers_FK3 FOREIGN KEY([answer_option_id]) REFERENCES[exams].[answer_options]([AnswerOptionID])
        ON DELETE CASCADE ON UPDATE CASCADE;

--11.Answer_Options table
ALTER TABLE exams.answer_options
ADD CONSTRAINT Answer_Option_FK FOREIGN KEY([question_id]) REFERENCES[exams].[QUESTIONS]([QuestionID])
ON DELETE NO ACTION ON UPDATE NO ACTION;

--13.EXAMS table
ALTER TABLE exams.Exams
ADD CONSTRAINT exam_FK1 FOREIGN KEY([course_id]) REFERENCES[academic].[COURSES]([CourseID])
    ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT exam_FK2 FOREIGN KEY([instructor_id]) REFERENCES [auth].[INSTRUCTORS]([instructorId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

--14.exam_questions table
ALTER TABLE exams.exam_questions
ADD CONSTRAINT exam_question_FK1 FOREIGN KEY([ExamID]) REFERENCES [exams].[EXAMS]([ExamID])
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT exam_question_FK2 FOREIGN KEY([QuestionID]) REFERENCES[exams].[QUESTIONS]([QuestionID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

--****************************** TRIGGERS ***********************************
--exams.trg_CheckExamQuestions Trigger
CREATE TRIGGER exams.trg_CheckExamQuestions
ON [exams].[exam_questions]
AFTER INSERT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM [exams].[exam_questions] eq
        JOIN inserted i ON eq.ExamId = i.ExamId
    )
    BEGIN
        RAISERROR('Exam does not contain questions !', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

--exams_StudentAnswerAudit Trigger
CREATE TRIGGER exams_StudentAnswerAudit
ON exams.student_answer
AFTER UPDATE
AS
BEGIN
    INSERT INTO exams.student_answer_audit (StudentAnswerID, OldAnswerOptionID, NewAnswerOptionID, OldTextAnswer, NewTextAnswer)
    SELECT
        d.StudentAnswerID,
        d.answer_option_id,
        i.answer_option_id,
        d.TextAnswer,
        i.TextAnswer
    FROM deleted d
    JOIN inserted i ON d.StudentAnswerID = i.StudentAnswerID
    WHERE ISNULL(d.answer_option_id, -1) <> ISNULL(i.answer_option_id, -1)
       OR ISNULL(d.TextAnswer, '') <> ISNULL(i.TextAnswer, '');
END;
GO

-- USER LOGs (to record the DML transactions on the tables)
CREATE TRIGGER auth.AfterInsert_User 
ON auth.USERS 
AFTER INSERT
AS
BEGIN
    INSERT INTO UserLog
        SELECT CONCAT(Fname, ' ', Lname), 'INSERT', GETDATE(), SYSTEM_USER
        FROM inserted;
END

--****************************** INSERTING DATA INTO TABLE ****************************
--1.ADD BRANCHES 
INSERT INTO [academic].[BRANCHES] (branchId, Name, Description)
VALUES
(1, 'CS', 'Computer Science department'),
(2, 'IS', 'Information Systems department'),
(3, 'IT', 'Information Technology department'),
(4, 'AI', 'Artificial Intelligence department'),
(5, 'Cybersecurity', 'Cybersecurity department');
        
--2.ADD TRACKS
INSERT INTO [academic].[TRACKS] (TrackID, Name, Description, BranchID)
VALUES
(1, 'Full Stack Development', 'Comprehensive web development track', 1), 
(2, 'Data Science', 'Data analysis and machine learning track', 4), 
(3, 'Cyber Security', 'Cybersecurity and network defense track', 5), 
(4, 'Artificial Intelligence', 'AI and machine learning engineering', 4), 
(5, 'UI/UX Design', 'User interface and experience design', 2), 
(6, 'DevOps Engineering', 'CI/CD and infrastructure management', 3), 
(7, 'Mobile App Development', 'Android and iOS development', 1), 
(8, 'Cloud Computing', 'Cloud services and architecture', 3), 
(9, 'Game Development', 'Game engine programming and design', 1), 
(10, 'Digital Marketing', 'Online marketing strategies', 2);

--3.ADD intackes
INSERT INTO [academic].[INTAKES] (IntakeID, StartDate, EndDATE, TrackID)
VALUES
(101, '2024-01-01', '2024-06-30', 1),
(102, '2024-03-15', '2024-09-15', 2),
(103, '2024-05-01', '2024-10-31', 3),
(104, '2024-07-01', '2024-12-31', 4),
(105, '2024-09-01', '2025-02-28', 5),
(106, '2025-01-01', '2025-06-30', 6),
(107, '2025-03-15', '2025-09-15', 7),
(108, '2025-05-01', '2025-10-31', 8),
(109, '2025-07-01', '2025-12-31', 9),
(110, '2025-09-01', '2026-02-28', 10);

--4.ADD Role
INSERT INTO auth.ROLES (RoleName, Description) VALUES
('Admin', 'Full system access'),
('Instructor', 'Manage courses and exams'),
('Student', 'Take exams and view results');

--5.PERMISSIONS table
INSERT INTO auth.PERMISSIONS (PermissionName, Description) VALUES
('Manage Exams', 'Create, update, delete exams'),
('View Grades', 'View student grades'),
('Manage Students', 'Add or update student details'),
('Take Exam', 'Access and answer exams');

--6.ROLE_PERMISSIONS table
-- Admin
INSERT INTO auth.ROLE_PERMISSIONS VALUES (1, 1), (1, 2), (1, 3), (1, 4);
-- Instructor
INSERT INTO auth.ROLE_PERMISSIONS VALUES (2, 1), (2, 2), (2, 3);
-- Student
INSERT INTO auth.ROLE_PERMISSIONS VALUES (3, 2), (3, 4);

--7.ADD STUDENT
CREATE PROCEDURE auth.AddStudent
(
    @Fname VARCHAR(20),
    @Lname VARCHAR(20),
    @Email VARCHAR(255),
    @Password VARCHAR(255),
    @Role VARCHAR(255),
    @roleID INT,
    @personalInfo VARCHAR(255),
    @Status VARCHAR(255)
)
AS
BEGIN
    DECLARE @NewUserId INT;

    INSERT INTO auth.USERS (Fname, Lname, Email, Password, Role, roleID)
    VALUES (@Fname, @Lname, @Email, @Password, @Role, @roleID);

    SET @NewUserId = SCOPE_IDENTITY();

    INSERT INTO auth.STUDENTS (studentID, personalInfo, Status)
    VALUES (@NewUserId, @personalInfo, @Status);
    SELECT @NewUserId AS InsertedUserID;
END;
---------------------
EXEC auth.AddStudent 'Ali', 'Hassan', 'ali.hassan@example.com', 'AliPass@123', 'Student',3 ,'Lives in Cairo, CS student', 'Active';
go
EXEC auth.AddStudent 'Sara', 'Mohamed', 'sara.mohamed@example.com', 'SaraPass@2025', 'Student', 3,'From Alexandria, loves AI projects', 'Active';
go
EXEC auth.AddStudent 'Omar', 'Khaled', 'omarr.khaled@example.com', 'OmarPass#999', 'Student', 3,'Senior student works part-time', 'Inactive';
go
EXEC auth.AddStudent 'Nouran', 'Hashad', 'nourann.hashad@example.com', 'Nouran@12345', 'Student', 3,'Lives in Giza, interested in smart agriculture', 'Active';
go
EXEC auth.AddStudent 'Ahmed', 'Srour', 'ahmed.srour@example.com', 'Srour#2025Dev', 'Student',3, 'Passionate about software development', 'Active';
go
EXEC auth.AddStudent 'Mohamed', 'Ibrahim', 'mohamed.ibrahim@example.com', 'Mido@55555', 'Student',3, 'Enjoys data analysis and ML', 'Active';
go
EXEC auth.AddStudent 'Hana', 'Mostafa', 'hana.mostafa@example.com', 'Hana@Design99', 'Student',3, 'UI/UX enthusiast, loves design', 'Active';
go
EXEC auth.AddStudent 'Youssef', 'Adel', 'youssef.adel@example.com', 'Adel@2025Full', 'Student', 3,'Full stack developer trainee', 'Inactive';
go
EXEC auth.AddStudent 'Mona', 'Salem', 'mona.salem@example.com', 'Mona@Cyber2025', 'Student', 3,'Interested in cybersecurity', 'Active';
go
EXEC auth.AddStudent 'Ali', 'Hassan', 'ali.hassann@example.com', 'AliPass@12345', 'Student', 3,'Lives in Cairo, CS student', 'Active';
go
EXEC auth.AddStudent 'Sara', 'Mohamed', 'sara.mohamed2@example.com', 'SaraPass@789', 'Student',3, 'From Alexandria, loves AI projects', 'Active';
go
EXEC auth.AddStudent 'Omar', 'Khaled', 'omar.khaledd@example.com', 'OmarPass2025', 'Student',3, 'Senior student, works part-time', 'Inactive';
go
EXEC auth.AddStudent 'Nouran', 'Hashad', 'nouran.hashadd@example.com', 'Nouran@1234', 'Student',3, 'Lives in Giza, interested in smart agriculture', 'Active';
go
EXEC auth.AddStudent 'Ahmed', 'Srour', 'ahmed.srourr@example.com', 'Srour9999', 'Student',3, 'Passionate about software development', 'Active';
go
EXEC auth.AddStudent 'Mohamed', 'Ibrahim', 'mohamed.iibrahim@example.com', 'Mido55555', 'Student',3, 'Enjoys data analysis and ML', 'Active';
go
EXEC auth.AddStudent 'Hana', 'Mostafa', 'hanaa.mostafa@example.com', 'Hana123456', 'Student',3, 'UI/UX enthusiast, loves design', 'Active';
go
EXEC auth.AddStudent 'Youssef', 'Adel', 'yousef.adel@example.com', 'Adel7777', 'Student',3, 'Full stack developer trainee', 'Inactive';
go
EXEC auth.AddStudent 'Mona', 'Salem', 'mona.saleem@example.com', 'Mona@Pass1', 'Student',3, 'Interested in cybersecurity', 'Active';
go
EXEC auth.AddStudent 'Karim', 'Fouad', 'kariem.fouad@example.com', 'Karim8888', 'Student',3, 'AI researcher, works on NLP', 'Active';
go

--8.ADD INSTRUCTOR 
CREATE PROCEDURE auth.AddInstructor
(
    @Fname VARCHAR(20),
    @Lname VARCHAR(20),
    @Email VARCHAR(255),
    @Password VARCHAR(255),
    @Role VARCHAR(255),
    @roleID INT,
    @Specilization varchar(255),
    @Qualifications VARCHAR(255),
    @YearOfExperience int
)
AS
BEGIN
    DECLARE @NewUserid INT;

    INSERT INTO auth.USERS (Fname, Lname, Email, Password, Role, roleID)
    VALUES (@Fname, @Lname, @Email, @Password, @Role, @roleID);

    SET @NewUserid = SCOPE_IDENTITY();

    INSERT INTO auth.INSTRUCTORS(instructorId,Specilization,Qualifications ,yearsOfExperience )
    VALUES (@NewUserid,@Specilization, @Qualifications, @YearOfExperience);
    SELECT @NewUserid AS InsertedUserID;
END;
-------------------------
EXEC auth.AddInstructor 
    'Ahmed', 'Kamal', 'ahmed.kamal@example.com', 'ahmedpass123', 'Instructor',2,
    'Web Development', 'Ph.D. in Computer Science', 15;
GO
EXEC auth.AddInstructor 
    'Mona', 'Fahmy', 'mona.fahmy@example.com', 'monapass456', 'Instructor',2,
    'Data Science', 'M.Sc. in Data Analytics', 10;
GO
EXEC auth.AddInstructor 
    'Hassan', 'Ali', 'hassan.ali@example.com', 'hassan@789', 'Instructor',2,
    'Cybersecurity', 'Certified Ethical Hacker', 12;
GO
EXEC auth.AddInstructor 
    'Lina', 'Adel', 'lina.adel@example.com', 'lina_pass', 'Instructor',2,
    'UI/UX Design', 'B.A. in Graphic Design, UX Certified', 8;
GO
EXEC auth.AddInstructor 
    'Amr', 'Said', 'amr.said@example.com', 'amr_secure_pass', 'Instructor',2,
    'Cloud Computing', 'AWS Certified Solutions Architect', 14;
GO
EXEC auth.AddInstructor 
    'Sarah', 'Wael', 'sarah.wael@example.com', 'sarahpass', 'Instructor',2,
    'Mobile Development', 'B.Sc. in Software Engineering', 9;
GO
EXEC auth.AddInstructor 
    'Youssef', 'Taha', 'youssef.taha@example.com', 'youssef_pass_123', 'Instructor',2,
    'Database Administration', 'Oracle Certified Professional', 18;
GO
EXEC auth.AddInstructor 
    'Nour', 'Elsayed', 'nour.elsayed@example.com', 'noura_pass_456', 'Instructor',2,
    'Machine Learning', 'Ph.D. in Artificial Intelligence', 11;
GO
EXEC auth.AddInstructor 
    'Karim', 'Fathy', 'karim.fathy@example.com', 'karim@pass', 'Instructor',2,
    'Quality Assurance', 'ISTQB Certified Tester', 7;
GO
EXEC auth.AddInstructor 
    'Mai', 'Mohamed', 'mai.mohamed@example.com', 'mai_pass_789', 'Instructor',2,
    'Project Management', 'PMP Certified', 13;
GO

--9.ADD MANAGER 
CREATE PROCEDURE auth.AddManager
(
    @Fname VARCHAR(20),
    @Lname VARCHAR(20),
    @Email VARCHAR(255),
    @Password VARCHAR(255),
    @Role VARCHAR(255), 
    @roleID INT
)
AS
BEGIN
    DECLARE @NewUserid INT;

    INSERT INTO auth.USERS (Fname, Lname, Email, Password, Role, roleID)
    VALUES (@Fname, @Lname, @Email, @Password, @Role, @roleID);

    SET @NewUserid = SCOPE_IDENTITY();

    INSERT INTO auth.training_manager(managerId)
    VALUES (@NewUserid);
    SELECT @NewUserid AS InsertedUserID;
END;

EXEC auth.AddManager 'Hany', 'Fawzy', 'hany.fawzy@example.com', 'hany@pass', 'Manager',1;
go
--10. COURSES table
INSERT INTO academic.COURSES (CourseID, Name, Description, MaxDegree, MinDegree, mng_id, intake_id)
VALUES
(1, 'Introduction to SQL', 'Learn the fundamentals of SQL', 100, 50, 30, 101),
(2, 'Advanced Python', 'Deep dive into Python for data analysis', 100, 50, 30, 102),
(3, 'Network Security Basics', 'Foundations of network security', 100, 50, 30, 103),
(4, 'UI/UX Principles', 'User interface and experience design principles', 100, 50, 30, 105),
(5, 'Introduction to DevOps', 'Continuous Integration and Continuous Deployment', 100, 50, 30, 106),
(6, 'Android Development', 'Building mobile applications with Android', 100, 50, 30, 107),
(7, 'Cloud Fundamentals', 'Introduction to cloud services (AWS, Azure, GCP)', 100, 50, 30, 108),
(8, 'Game Design with Unity', 'Creating games using the Unity engine', 100, 50, 30, 109),
(9, 'Search Engine Optimization', 'Strategies for improving website ranking', 100, 50, 30, 110),
(10, 'Machine Learning Basics', 'Core concepts of machine learning', 100, 50, 30, 104);

--11.instr_intake_course table
INSERT INTO academic.instr_intake_course (instructor_id, intake_id, course_id, HireDate)
VALUES
(20, 101, 1, '2024-01-01'),
(21, 102, 2, '2024-03-15'),
(22, 103, 3, '2024-05-01'),
(23, 105, 4, '2024-09-01'),
(24, 106, 5, '2025-01-01'),
(25, 107, 6, '2025-03-15'),
(26, 108, 7, '2025-05-01'),
(27, 109, 8, '2025-07-01'),
(28, 110, 9, '2025-09-01'),
(29, 104, 10, '2024-07-01');

--12.EXAMS table
INSERT INTO exams.EXAMS (ExamID, StartTime, EndTime, TotalPoints, Type, course_id, instructor_id)
VALUES
(1, '2025-08-10 10:00:00', '2025-08-10 12:00:00', 100, 'Midterm', 1, 20),
(2, '2025-09-01 14:00:00', '2025-09-01 16:00:00', 100, 'Final', 2, 21),
(3, '2025-09-15 09:00:00', '2025-09-15 11:00:00', 100, 'Midterm', 3, 22),
(4, '2025-10-01 13:00:00', '2025-10-01 15:00:00', 100, 'Final', 4, 23),
(5, '2025-10-15 10:00:00', '2025-10-15 12:00:00', 100, 'Midterm', 5, 24),
(6, '2025-11-01 14:00:00', '2025-11-01 16:00:00', 100, 'Final', 6, 25),
(7, '2025-11-15 09:00:00', '2025-11-15 11:00:00', 100, 'Midterm', 7, 26),
(8, '2025-12-01 13:00:00', '2025-12-01 15:00:00', 100, 'Final', 8, 27),
(9, '2025-12-15 10:00:00', '2025-12-15 12:00:00', 100, 'Midterm', 9, 28),
(10, '2026-01-01 14:00:00', '2026-01-01 16:00:00', 100, 'Final', 10, 29);

--13.ADD QUESTIONS 
INSERT INTO exams.QUESTIONS (QuestionID, Content, Type, Points, CorrectAnswer, BestAcceptedAnswer, ExamID)
VALUES
(1, 'What is a primary key?', 'MCQ', 10, 'A unique identifier for a row.', 'A unique identifier for a row.', 1),
(2, 'Which statement is used to delete data from a table?', 'MCQ', 10, 'DELETE', 'DELETE', 1),
(3, 'What is the purpose of a JOIN clause?', 'MCQ', 10, 'To combine rows from two or more tables.', 'To combine rows from two or more tables based on related columns.', 1),
(4, 'Which of the following is a mutable data type in Python?', 'MCQ', 10, 'List', 'List', 2),
(5, 'What is the output of "3" + "5" in Python?', 'MCQ', 10, '"35"', '"35"', 2),
(6, 'What is a firewall?', 'MCQ', 10, 'A security system that controls network traffic.', 'A security system that controls incoming and outgoing network traffic.', 3),
(7, 'What does UI stand for?', 'MCQ', 10, 'User Interface', 'User Interface', 4),
(8, 'What is the main goal of DevOps?', 'MCQ', 10, 'To shorten the systems development life cycle.', 'To shorten the systems development life cycle and provide continuous delivery with high software quality.', 5),
(9, 'Which programming language is primarily used for Android?', 'MCQ', 10, 'Kotlin or Java', 'Kotlin or Java', 6),
(10, 'What is IaaS?', 'MCQ', 10, 'Infrastructure as a Service', 'Infrastructure as a Service', 7),
(11, 'Which component is essential for building a game in Unity?', 'MCQ', 10, 'GameObject', 'GameObject', 8),
(12, 'What is the difference between on-page and off-page SEO?', 'Text', 10, 'On-page SEO refers to optimizing website elements, while off-page SEO involves external factors like backlinks.', NULL, 9),
(13, 'Define the term "Machine Learning".', 'Text', 10, 'A field of AI where systems learn from data to make predictions.', NULL, 10),
(14, 'What is the difference between a primary key and a foreign key?', 'Text', 10, 'A primary key uniquely identifies a record, while a foreign key links two tables together.', NULL, 1),
(15, 'What is the "DataFrame" in Python used for?', 'Text', 10, 'A 2-dimensional labeled data structure with columns of potentially different types.', NULL, 2);

--14.exam_questions table
INSERT INTO exams.exam_questions (ExamID, QuestionID)
VALUES
(1, 1), (1, 2), (1, 3), (1, 14),
(2, 4), (2, 5), (2, 15),
(3, 6),
(4, 7),
(5, 8),
(6, 9),
(7, 10),
(8, 11),
(9, 12),
(10, 13);

--15.Answer_Options table
INSERT INTO exams.answer_options (AnswerOptionID, Content, IsCorrect, question_id)
VALUES
(1, 'A unique identifier for a row.', 'Y', 1),
(2, 'A key that links two tables.', 'N', 1),
(3, 'A non-unique identifier.', 'N', 1),
(4, 'An index on a column.', 'N', 1),

(5, 'UPDATE', 'N', 2),
(6, 'REMOVE', 'N', 2),
(7, 'DELETE', 'Y', 2),
(8, 'DROP', 'N', 2),

(9, 'To combine rows from two or more tables.', 'Y', 3),
(10, 'To filter data.', 'N', 3),
(11, 'To create a new table.', 'N', 3),
(12, 'To sort the results.', 'N', 3),

(13, 'Tuple', 'N', 4),
(14, 'List', 'Y', 4),
(15, 'String', 'N', 4),
(16, 'Integer', 'N', 4),

(17, '8', 'N', 5),
(18, '35', 'Y', 5),
(19, 'An error', 'N', 5),
(20, 'None of the above', 'N', 5),

(21, 'A system to protect against viruses.', 'N', 6),
(22, 'A security system that controls network traffic.', 'Y', 6),
(23, 'A software to remove malware.', 'N', 6),
(24, 'A hardware device to block spam emails.', 'N', 6),

(25, 'Universal Infrastructure', 'N', 7),
(26, 'User Interface', 'Y', 7),
(27, 'Unified Internet', 'N', 7),
(28, 'Unstructured Information', 'N', 7),

(29, 'To shorten the systems development life cycle.', 'Y', 8),
(30, 'To increase system complexity.', 'N', 8),
(31, 'To reduce code quality.', 'N', 8),
(32, 'To separate development and operations.', 'N', 8),

(33, 'Swift', 'N', 9),
(34, 'C++', 'N', 9),
(35, 'Kotlin or Java', 'Y', 9),
(36, 'JavaScript', 'N', 9),

(37, 'Identity and Access Service', 'N', 10),
(38, 'Internet as a Service', 'N', 10),
(39, 'Infrastructure as a Service', 'Y', 10),
(40, 'Integrated Application Service', 'N', 10),

(41, 'A shader', 'N', 11),
(42, 'A script', 'N', 11),
(43, 'A GameObject', 'Y', 11),
(44, 'A camera', 'N', 11),

(45, 'A server-side optimization technique.', 'N', 12),
(46, 'A method to optimize search engine ranking.', 'N', 12),
(47, 'The process of optimizing website elements and external factors.', 'N', 12),

(48, 'A type of AI that learns from data.', 'N', 13),
(49, 'A statistical model.', 'N', 13),
(50, 'A field of AI where systems learn from data to make predictions.', 'N', 13),

(51, 'A key to identify a record and a key to link tables.', 'N', 14),
(52, 'A unique identifier and a non-unique identifier.', 'N', 14),
(53, 'Both are used to link tables.', 'N', 14),

(54, 'A data structure in Python.', 'N', 15),
(55, 'A table-like structure for data manipulation.', 'N', 15),
(56, 'A 2-dimensional labeled data structure with columns of potentially different types.', 'N', 15);
go
--16.Student_Answers table
INSERT INTO exams.student_answer (StudentAnswerID, student_id, question_id, answer_option_id, TextAnswer, points)
VALUES
(1, 1, 1, 1, NULL, 10),
(2, 2, 2, 7, NULL, 10),
(3, 3, 3, 9, NULL, 10),
(4, 4, 4, 14, NULL, 10),
(5, 5, 5, 18, NULL, 10),
(6, 6, 6, 22, NULL, 10),
(7, 7, 7, 26, NULL, 10),
(8, 8, 8, 29, NULL, 10),
(9, 9, 9, 35, NULL, 10),
(10,10, 10, 39, NULL, 10),
(11, 1, 11, 43, NULL, 10),
(12, 2, 12, NULL, 'On-page SEO refers to optimizing website elements, while off-page SEO involves external factors like backlinks.', 10),
(13, 3, 13, NULL, 'A field of AI where systems learn from data to make predictions.', 10),
(14, 4, 14, NULL, 'A primary key uniquely identifies a record, while a foreign key links two tables together.', 10),
(15, 5, 15, NULL, 'A 2-dimensional labeled data structure with columns of potentially different types.', 10),
(16, 6, 1, 1, NULL, 10),
(17, 7, 2, 7, NULL, 10),
(18, 8, 3, 9, NULL, 10),
(19, 9, 4, 14, NULL, 10),
(20, 1, 5, 18, NULL, 10),
(21, 2, 6, 22, NULL, 10),
(22, 3, 7, 26, NULL, 10),
(23, 4, 8, 29, NULL, 10),
(24, 5, 9, 35, NULL, 10),
(25, 6, 10, 39, NULL, 10),
(26, 7, 11, 43, NULL, 10),
(27, 8, 12, NULL, 'On-page SEO refers to optimizing website elements, while off-page SEO involves external factors like backlinks.', 10),
(28, 9, 13, NULL, 'A field of AI where systems learn from data to make predictions.', 10),
(29, 10, 14, NULL, 'A primary key uniquely identifies a record, while a foreign key links two tables together.', 10),
(30, 1, 15, NULL, 'A 2-dimensional labeled data structure with columns of potentially different types.', 10),
(31, 2, 1, 1, NULL, 10),
(32, 3, 2, 7, NULL, 10),
(33, 4, 3, 9, NULL, 10),
(34, 5, 4, 14, NULL, 10),
(35, 6, 5, 18, NULL, 10),
(36, 8, 6, 22, NULL, 10),
(37, 9, 7, 26, NULL, 10);
go

--******************************** CREATE VIEWS *************************************
--show all student info
CREATE VIEW auth.vw_AllStudents AS
SELECT 
    u.userId,
    u.Fname,
    u.Lname,
    u.Email,
    u.Role,
    s.personalInfo,
    s.Status
FROM auth.USERS u
JOIN auth.STUDENTS s ON u.userId = s.studentID;

--show all instructor info
CREATE VIEW vw_AllInstructors AS
SELECT 
    u.userId,
    u.Fname,
    u.Lname,
    u.Email,
    u.Role,
    i.Specilization,
    i.Qualifications,
    i.yearsOfExperience
FROM auth.USERS u
JOIN auth.INSTRUCTORS i ON u.userId = i.instructorId;

-- course info
CREATE VIEW academic.vw_CoursesDetails AS
SELECT 
    c.CourseID,
    c.Name AS CourseName,
    c.Description AS CourseDesc,
    c.MaxDegree,
    c.MinDegree,
    t.Name AS TrackName,
    b.Name AS BranchName,
    i.IntakeID,
    i.StartDate,
    i.EndDate
FROM academic.COURSES c
LEFT JOIN academic.INTAKES i ON c.intake_id = i.IntakeID
LEFT JOIN academic.TRACKS t ON i.TrackID = t.TrackID
LEFT JOIN academic.BRANCHES b ON t.BranchID = b.branchId;


-- Exam info
CREATE VIEW exams.vw_ExamsWithCoursesAndInstructors AS
SELECT 
    e.ExamID,
    e.Type,
    e.StartTime,
    e.EndTime,
    e.TotalPoints,
    c.Name AS CourseName,
    u.Fname + ' ' + u.Lname AS InstructorName
FROM exams.EXAMS e
JOIN academic.COURSES c ON e.course_id = c.CourseID
JOIN auth.INSTRUCTORS i ON e.instructor_id = i.instructorId
JOIN auth.USERS u ON i.instructorId = u.userId;


-- show student answer 
CREATE VIEW vw_StudentAnswersDetails AS
SELECT 
    sa.StudentAnswerID,
    u.Fname + ' ' + u.Lname AS StudentName,
    q.Content AS Question,
    sa.TextAnswer,
    ao.Content AS ChosenOption,
    sa.points
FROM exams.student_answer sa
JOIN auth.STUDENTS s ON sa.student_id = s.studentID
JOIN auth.USERS u ON s.studentID = u.userId
JOIN exams.QUESTIONS q ON sa.question_id = q.QuestionID
LEFT JOIN exams.answer_options ao ON sa.answer_option_id = ao.AnswerOptionID;

--- show all students grades
CREATE VIEW vw_StudentResults AS
SELECT 
    u.userId AS StudentID,
    u.Fname + ' ' + u.Lname AS StudentName,
    c.Name AS CourseName,
    SUM(sa.points) AS TotalPoints
FROM exams.student_answer sa
JOIN auth.STUDENTS s ON sa.student_id = s.studentID
JOIN auth.USERS u ON s.studentID = u.userId
JOIN exams.QUESTIONS q ON sa.question_id = q.QuestionID
JOIN academic.COURSES c ON q.ExamID = c.CourseID
GROUP BY u.userId, u.Fname, u.Lname, c.Name;



-- (Students with Intake/Track/Branch)
CREATE VIEW vw_StudentsWithIntakeTrackBranch AS
SELECT 
    u.userId AS StudentID,
    u.Fname + ' ' + u.Lname AS StudentName,
    s.Status,
    i.IntakeID,
    i.StartDate,
    i.EndDate,
    t.TrackID,
    t.Name AS TrackName,
    b.branchId,
    b.Name AS BranchName
FROM auth.STUDENTS s
JOIN auth.USERS u ON s.studentID = u.userId
JOIN academic.INTAKES i ON i.IntakeID IN (
    SELECT intake_id 
    FROM academic.COURSES c 
    JOIN exams.student_answer sa ON c.CourseID = sa.question_id
    WHERE sa.student_id = s.studentID
)
JOIN academic.TRACKS t ON i.TrackID = t.TrackID
JOIN academic.BRANCHES b ON t.BranchID = b.branchId

--************************** CREATE INDEXES ****************************************
CREATE NONCLUSTERED INDEX UserName_index
ON auth.USERS (Fname)
INCLUDE (Lname);

CREATE NONCLUSTERED INDEX CourseName_index
ON [academic].[COURSES] ([Name]);

CREATE NONCLUSTERED INDEX BranchName_index
ON [academic].[BRANCHES] ([Name]);

CREATE NONCLUSTERED INDEX TrackName_index
ON [academic].[TRACKS] ([Name]);

--************************************ FUNCTIONS ***************************************
--Search user by id
CREATE FUNCTION auth.SearchUserID (@ID INT)
RETURNS TABLE 
AS
RETURN
(
SELECT CONCAT(Fname, Lname) AS 'User Name', Email, Role, lastLogin
FROM auth.USERS
WHERE userId = @ID
);

-- if user name Exists or not
CREATE FUNCTION auth.UserExists(@name VARCHAR(255))
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT = 0; 
    DECLARE @Fname VARCHAR(255);
    DECLARE @Lname VARCHAR(255);

    IF CHARINDEX(' ', @name) > 0
    BEGIN
        SET @Fname = SUBSTRING(@name, 1, CHARINDEX(' ', @name)-1);
        SET @Lname = SUBSTRING(@name, CHARINDEX(' ', @name)+1, LEN(@name)-CHARINDEX(' ', @name));
    END
    ELSE
    BEGIN
        SET @Fname = @name; 
        SET @Lname = '';
    END
    IF EXISTS (SELECT 1 FROM auth.USERS WHERE Fname = @Fname AND Lname = @Lname)
        SET @Result = 1;

    RETURN @Result;
END
GO



--INSTRUCTOR FULL INFO WITH HIS NAME
CREATE FUNCTION auth.InstructorInfo(@Name VARCHAR(255))
RETURNS TABLE
AS
RETURN
(
SELECT 
   I.instructorId, 
    U.Email,
    I.Qualifications,
    I.Specilization,
    I.yearsOfExperience,
    U.lastLogin
FROM auth.USERS U
JOIN auth.INSTRUCTORS I ON U.userId = I.instructorId
WHERE U.Fname =  SUBSTRING(@name, 1, CHARINDEX(' ', @name)-1)  AND U.Lname = SUBSTRING(@name, CHARINDEX(' ', @name)+1, LEN(@name)-CHARINDEX(' ', @name))
)

-- INTAKE TRACK COURSES WITH intake id
CREATE FUNCTION academic.IntakeTrackCources(@Intake INT, @Track INT)
RETURNS @intake_track_course TABLE (Intake VARCHAR(255), Track VARCHAR(255),NumberOfCourses INT ,Courses VARCHAR(MAX))
AS 
BEGIN 
    INSERT INTO @intake_track_course
        SELECT 
            I.IntakeID,
            T.TrackID,
            COUNT(C.CourseID),
            STRING_AGG(C.Name, ', ')
        FROM academic.INTAKES I
        JOIN academic.COURSES C ON I.IntakeID = C.intake_id
        JOIN academic.TRACKS T ON I.TrackID = T.TrackID
        WHERE I.IntakeID = @Intake AND T.TrackID = @Track
        GROUP BY I.IntakeID, T.TrackID
        RETURN
END

--- num of exams student has attend
CREATE FUNCTION fn_GetExamCountForStudent(@studentId INT)
RETURNS INT
AS
BEGIN
    DECLARE @ExamCount INT;

    SELECT @ExamCount = COUNT(DISTINCT eq.ExamID)
    FROM exams.student_answer sa
    JOIN exams.QUESTIONS q ON sa.question_id = q.QuestionID
    JOIN exams.exam_questions eq ON q.QuestionID = eq.QuestionID
    WHERE sa.student_id = @studentId;

    RETURN @ExamCount;
END;









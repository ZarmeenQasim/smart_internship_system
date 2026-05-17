-- ============================================================
-- Smart Internship Management System
-- Milestone 5 — Data Population (DML)
-- Munazza Sana & Zarmeen Qasim
-- ============================================================

USE smart_internship_db;

-- ============================================================
-- IMPORTANT: Before running LOAD DATA INFILE, you must allow
-- MySQL to read local files. Run this ONE TIME in Workbench:
--   SET GLOBAL local_infile = 1;
-- Also make sure all 11 CSV files are placed in one folder.
-- Update the file paths below to match YOUR folder location.
-- Example path: C:/Users/FINDER/OneDrive/Desktop/smartinternship/
-- ============================================================

-- ============================================================
-- SECTION 1: LOAD DATA INFILE (CSV → Tables)
-- ============================================================

-- 1. Departments
LOAD DATA LOCAL INFILE 'C:/Users/FINDER/OneDrive/Desktop/smartinternship/departments.csv'
INTO TABLE Departments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(DepartmentID, DepartmentName);

-- 2. Skills
LOAD DATA LOCAL INFILE 'C:/Users/FINDER/OneDrive/Desktop/smartinternship/skills.csv'
INTO TABLE Skills
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(SkillID, SkillName);

-- 3. Companies
LOAD DATA LOCAL INFILE 'C:/Users/FINDER/OneDrive/Desktop/smartinternship/companies.csv'
INTO TABLE Companies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(CompanyID, CompanyName, Location, ContactEmail, IndustryType, Website, HRContact);

-- 4. Students
LOAD DATA LOCAL INFILE 'C:/Users/FINDER/OneDrive/Desktop/smartinternship/students.csv'
INTO TABLE Students
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(StudentID, Name, Email, Phone, Department, CGPA, Semester, DegreeProgram);

-- 5. Internships
LOAD DATA LOCAL INFILE 'C:/Users/FINDER/OneDrive/Desktop/smartinternship/internships.csv'
INTO TABLE Internships
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(InternshipID, CompanyID, Title, Description, Deadline, InternshipType, Duration, Stipend, WorkMode, InternshipCategory);

-- 6. EligibilityCriteria
LOAD DATA LOCAL INFILE 'C:/Users/FINDER/OneDrive/Desktop/smartinternship/eligibility_criteria.csv'
INTO TABLE EligibilityCriteria
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(CriteriaID, InternshipID, MinCGPA, MinSemester, ExperienceLevel);

-- 7. EligibleDepartments
LOAD DATA LOCAL INFILE 'C:/Users/FINDER/OneDrive/Desktop/smartinternship/eligible_departments.csv'
INTO TABLE EligibleDepartments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(EligDeptID, InternshipID, DepartmentID);

-- 8. InternshipSkills
LOAD DATA LOCAL INFILE 'C:/Users/FINDER/OneDrive/Desktop/smartinternship/internship_skills.csv'
INTO TABLE InternshipSkills
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(InternshipID, SkillID);

-- 9. StudentSkills
LOAD DATA LOCAL INFILE 'C:/Users/FINDER/OneDrive/Desktop/smartinternship/student_skills.csv'
INTO TABLE StudentSkills
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(StudentID, SkillID);

-- 10. Applications
LOAD DATA LOCAL INFILE 'C:/Users/FINDER/OneDrive/Desktop/smartinternship/applications.csv'
INTO TABLE Applications
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ApplicationID, StudentID, InternshipID, Status, AppliedDate);

-- 11. Feedback
LOAD DATA LOCAL INFILE 'C:/Users/FINDER/OneDrive/Desktop/smartinternship/feedback.csv'
INTO TABLE Feedback
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(FeedbackID, StudentID, CompanyID, InternshipID, Rating, Comments);


-- ============================================================
-- SECTION 2: UPDATE OPERATIONS (with WHERE clause)
-- ============================================================

-- UPDATE 1: Student Jordan Blake (StudentID=4) improved her CGPA
--           after grade re-evaluation in semester 6
UPDATE Students
SET    CGPA = 3.90
WHERE  StudentID = 4;

-- UPDATE 2: Internship for "Electrical engineer" (InternshipID=6)
--           deadline extended by the company
UPDATE Internships
SET    Deadline = '2026-08-30'
WHERE  InternshipID = 6;

-- UPDATE 3: Application status updated from Pending to Accepted
--           for StudentID=30 who applied to InternshipID=100
UPDATE Applications
SET    Status = 'Accepted'
WHERE  StudentID = 30
  AND  InternshipID = 100;


-- ============================================================
-- SECTION 3: DELETE OPERATIONS (with WHERE clause)
-- ============================================================

-- DELETE 1: Remove application where student (StudentID=9)
--           withdrew their Ineligible application for InternshipID=36
DELETE FROM Applications
WHERE  StudentID    = 9
  AND  InternshipID = 36;

-- DELETE 2: Remove feedback entry FeedbackID=100
--           (submitted by mistake / duplicate entry)
DELETE FROM Feedback
WHERE  FeedbackID = 100;


-- ============================================================
-- SECTION 4: VALIDATION QUERIES
-- ============================================================

-- ------------------------------------------------------------
-- V1: COUNT(*) for every table
-- ------------------------------------------------------------
SELECT 'Departments'       AS TableName, COUNT(*) AS RowCount FROM Departments
UNION ALL
SELECT 'Skills',                         COUNT(*) FROM Skills
UNION ALL
SELECT 'Companies',                      COUNT(*) FROM Companies
UNION ALL
SELECT 'Students',                       COUNT(*) FROM Students
UNION ALL
SELECT 'Internships',                    COUNT(*) FROM Internships
UNION ALL
SELECT 'EligibilityCriteria',            COUNT(*) FROM EligibilityCriteria
UNION ALL
SELECT 'EligibleDepartments',            COUNT(*) FROM EligibleDepartments
UNION ALL
SELECT 'InternshipSkills',               COUNT(*) FROM InternshipSkills
UNION ALL
SELECT 'StudentSkills',                  COUNT(*) FROM StudentSkills
UNION ALL
SELECT 'Applications',                   COUNT(*) FROM Applications
UNION ALL
SELECT 'Feedback',                       COUNT(*) FROM Feedback;

-- ------------------------------------------------------------
-- V2: NULL checks on key columns
-- ------------------------------------------------------------

-- Students: Name, Email, Department, DegreeProgram must not be NULL
SELECT 'Students NULL check' AS CheckName, COUNT(*) AS NullCount
FROM   Students
WHERE  Name IS NULL OR Email IS NULL
    OR Department IS NULL OR DegreeProgram IS NULL;

-- Internships: Title, InternshipType, WorkMode must not be NULL
SELECT 'Internships NULL check' AS CheckName, COUNT(*) AS NullCount
FROM   Internships
WHERE  Title IS NULL OR InternshipType IS NULL OR WorkMode IS NULL;

-- Applications: StudentID, InternshipID, AppliedDate must not be NULL
SELECT 'Applications NULL check' AS CheckName, COUNT(*) AS NullCount
FROM   Applications
WHERE  StudentID IS NULL OR InternshipID IS NULL OR AppliedDate IS NULL;

-- Companies: CompanyName, ContactEmail must not be NULL
SELECT 'Companies NULL check' AS CheckName, COUNT(*) AS NullCount
FROM   Companies
WHERE  CompanyName IS NULL OR ContactEmail IS NULL;

-- ------------------------------------------------------------
-- V3: JOIN-based foreign key integrity checks
-- ------------------------------------------------------------

-- V3a: Every Application links to a valid Student and Internship
SELECT  a.ApplicationID,
        s.Name        AS StudentName,
        i.Title       AS InternshipTitle,
        a.Status,
        a.AppliedDate
FROM    Applications a
JOIN    Students     s ON s.StudentID    = a.StudentID
JOIN    Internships  i ON i.InternshipID = a.InternshipID
ORDER BY a.ApplicationID
LIMIT 20;

-- V3b: Every Internship belongs to a valid Company
SELECT  i.InternshipID,
        i.Title,
        c.CompanyName,
        i.InternshipType,
        i.WorkMode,
        i.Stipend
FROM    Internships i
JOIN    Companies   c ON c.CompanyID = i.CompanyID
ORDER BY i.InternshipID
LIMIT 20;

-- V3c: Every Feedback links a valid Student, Company, and Internship
SELECT  f.FeedbackID,
        s.Name        AS StudentName,
        c.CompanyName,
        i.Title       AS InternshipTitle,
        f.Rating
FROM    Feedback    f
JOIN    Students    s ON s.StudentID    = f.StudentID
JOIN    Companies   c ON c.CompanyID   = f.CompanyID
JOIN    Internships i ON i.InternshipID = f.InternshipID
ORDER BY f.FeedbackID
LIMIT 20;

-- V3d: EligibleDepartments — both Internship and Department exist
SELECT  ed.EligDeptID,
        i.Title          AS InternshipTitle,
        d.DepartmentName
FROM    EligibleDepartments ed
JOIN    Internships         i  ON i.InternshipID = ed.InternshipID
JOIN    Departments         d  ON d.DepartmentID = ed.DepartmentID
ORDER BY ed.InternshipID
LIMIT 20;

-- V3e: StudentSkills — both Student and Skill exist
SELECT  ss.StudentID,
        s.Name      AS StudentName,
        sk.SkillName
FROM    StudentSkills ss
JOIN    Students      s  ON s.StudentID = ss.StudentID
JOIN    Skills        sk ON sk.SkillID  = ss.SkillID
ORDER BY ss.StudentID
LIMIT 20;

-- ============================================================
-- END OF MILESTONE 5 SCRIPT
-- ============================================================

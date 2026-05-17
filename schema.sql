-- Smart Internship Management System
-- DDL Script
-- Munazza Sana & Zarmeen Qasim

CREATE DATABASE IF NOT EXISTS smart_internship_db;
USE smart_internship_db;

-- 1. Departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(50) NOT NULL UNIQUE
);

-- 2. Skills
CREATE TABLE Skills (
    SkillID INT PRIMARY KEY AUTO_INCREMENT,
    SkillName VARCHAR(50) NOT NULL UNIQUE
);

-- 3. Companies
CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY AUTO_INCREMENT,
    CompanyName VARCHAR(100) NOT NULL,
    Location VARCHAR(100),
    ContactEmail VARCHAR(100) UNIQUE,
    IndustryType VARCHAR(50),
    Website VARCHAR(150),
    HRContact VARCHAR(100)
);

-- 4. Students
CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    Department VARCHAR(50) NOT NULL,
    CGPA DECIMAL(3,2) CHECK (CGPA >= 0.00 AND CGPA <= 4.00),
    Semester INT CHECK (Semester BETWEEN 1 AND 8),
    DegreeProgram VARCHAR(100) NOT NULL
);

-- 5. Internships
CREATE TABLE Internships (
    InternshipID INT PRIMARY KEY AUTO_INCREMENT,
    CompanyID INT NOT NULL,
    Title VARCHAR(100) NOT NULL,
    Description TEXT,
    Deadline DATE,
    InternshipType ENUM('Paid','Unpaid','Academic Credit') NOT NULL,
    Duration INT,
    Stipend DECIMAL(10,2) DEFAULT 0,
    WorkMode ENUM('Remote','Onsite','Hybrid') NOT NULL,
    InternshipCategory VARCHAR(50),
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

-- 6. Applications
CREATE TABLE Applications (
    ApplicationID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT NOT NULL,
    InternshipID INT NOT NULL,
    Status ENUM('Pending','Accepted','Rejected','Ineligible')
           DEFAULT 'Pending',
    AppliedDate DATE NOT NULL,
    UNIQUE (StudentID, InternshipID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (InternshipID) REFERENCES Internships(InternshipID)
);

-- 7. Feedback
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT NOT NULL,
    CompanyID INT NOT NULL,
    InternshipID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comments TEXT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID),
    FOREIGN KEY (InternshipID) REFERENCES Internships(InternshipID)
);

-- 8. EligibilityCriteria
CREATE TABLE EligibilityCriteria (
    CriteriaID INT PRIMARY KEY AUTO_INCREMENT,
    InternshipID INT NOT NULL UNIQUE,
    MinCGPA DECIMAL(3,2),
    MinSemester INT,
    ExperienceLevel ENUM('None','Beginner','Intermediate'),
    FOREIGN KEY (InternshipID) REFERENCES Internships(InternshipID)
);

-- 9. EligibleDepartments
CREATE TABLE EligibleDepartments (
    EligDeptID INT PRIMARY KEY AUTO_INCREMENT,
    InternshipID INT NOT NULL,
    DepartmentID INT NOT NULL,
    FOREIGN KEY (InternshipID) REFERENCES Internships(InternshipID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- 10. InternshipSkills
CREATE TABLE InternshipSkills (
    InternshipID INT NOT NULL,
    SkillID INT NOT NULL,
    PRIMARY KEY (InternshipID, SkillID),
    FOREIGN KEY (InternshipID) REFERENCES Internships(InternshipID),
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID)
);

-- 11. StudentSkills
CREATE TABLE StudentSkills (
    StudentID INT NOT NULL,
    SkillID INT NOT NULL,
    PRIMARY KEY (StudentID, SkillID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID)
);

-- Indexes
CREATE INDEX idx_app_student
    ON Applications(StudentID);
CREATE INDEX idx_app_internship
    ON Applications(InternshipID);
CREATE INDEX idx_internship_company
    ON Internships(CompanyID);
CREATE INDEX idx_feedback_company
    ON Feedback(CompanyID);
CREATE INDEX idx_feedback_internship
    ON Feedback(InternshipID);
CREATE INDEX idx_eligdept_internship
    ON EligibleDepartments(InternshipID);
CREATE INDEX idx_eligdept_department
    ON EligibleDepartments(DepartmentID);
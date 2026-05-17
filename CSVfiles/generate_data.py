from faker import Faker
import csv
import random

fake = Faker()
random.seed(42)

# ── 1. Departments (lookup table - fixed list is correct)
departments_data = [
    (1, 'BSCS'),
    (2, 'BSSE'),
    (3, 'BSIT'),
    (4, 'BSAI'),
    (5, 'BBA')
]

with open('departments.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['DepartmentID', 'DepartmentName'])
    for row in departments_data:
        writer.writerow(row)

print("departments.csv done —", len(departments_data), "rows")

# ── 2. Skills (lookup table - fixed list is correct)
skills_data = [
    (1, 'Python'), (2, 'SQL'), (3, 'Java'),
    (4, 'JavaScript'), (5, 'Communication'),
    (6, 'Excel'), (7, 'React'), (8, 'Machine Learning'),
    (9, 'Figma'), (10, 'AutoCAD'),
    (11, 'Accounting'), (12, 'Data Analysis'),
    (13, 'C++'), (14, 'Teamwork'), (15, 'MS Office'),
    (16, 'Django'), (17, 'Flutter'), (18, 'Kotlin'),
    (19, 'Swift'), (20, 'PHP')
]

with open('skills.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['SkillID', 'SkillName'])
    for row in skills_data:
        writer.writerow(row)

print("skills.csv done —", len(skills_data), "rows")

# ── 3. Companies — 100 rows
company_ids = list(range(1, 101))
industry_types = ['Technology', 'Finance', 'Healthcare',
                  'Marketing', 'Education', 'Engineering']

with open('companies.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['CompanyID', 'CompanyName', 'Location',
                     'ContactEmail', 'IndustryType', 'Website', 'HRContact'])
    for i in company_ids:
        writer.writerow([
            i,
            fake.company(),
            fake.city(),
            fake.unique.company_email(),
            random.choice(industry_types),
            fake.url(),
            fake.name()
        ])

print("companies.csv done — 100 rows")

# ── 4. Students — 100 rows
student_ids = list(range(1, 101))
dept_ids = [row[0] for row in departments_data]
degree_map = {
    1: 'BS Computer Science',
    2: 'BS Software Engineering',
    3: 'BS Information Technology',
    4: 'BS Artificial Intelligence',
    5: 'Bachelor of Business Administration'
}

with open('students.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['StudentID', 'Name', 'Email', 'Phone',
                     'Department', 'CGPA', 'Semester', 'DegreeProgram'])
    for i in student_ids:
        dept_id = random.choice(dept_ids)
        dept_name = departments_data[dept_id - 1][1]
        writer.writerow([
            i,
            fake.name(),
            fake.unique.email(),
            fake.phone_number()[:15],
            dept_name,
            round(random.uniform(2.0, 4.0), 2),
            random.randint(1, 8),
            degree_map[dept_id]
        ])

print("students.csv done — 100 rows")

# ── 5. Internships — 100 rows
internship_ids = list(range(1, 101))
internship_types = ['Paid', 'Unpaid', 'Academic Credit']
work_modes = ['Remote', 'Onsite', 'Hybrid']
categories = ['Engineering', 'Design', 'Marketing',
              'Finance', 'Data Science', 'HR']

with open('internships.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['InternshipID', 'CompanyID', 'Title', 'Description',
                     'Deadline', 'InternshipType', 'Duration',
                     'Stipend', 'WorkMode', 'InternshipCategory'])
    for i in internship_ids:
        itype = random.choice(internship_types)
        writer.writerow([
            i,
            random.choice(company_ids),
            fake.job(),
            fake.paragraph(nb_sentences=2),
            fake.date_between(start_date='+10d', end_date='+90d'),
            itype,
            random.randint(4, 24),
            round(random.uniform(10000, 50000), 2) if itype == 'Paid' else 0,
            random.choice(work_modes),
            random.choice(categories)
        ])

print("internships.csv done — 100 rows")

# ── 6. Applications — 100 rows
with open('applications.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['ApplicationID', 'StudentID', 'InternshipID',
                     'Status', 'AppliedDate'])
    statuses = ['Pending', 'Accepted', 'Rejected', 'Ineligible']
    used = set()
    count = 1
    while count <= 100:
        sid = random.choice(student_ids)
        iid = random.choice(internship_ids)
        if (sid, iid) not in used:
            used.add((sid, iid))
            writer.writerow([
                count, sid, iid,
                random.choice(statuses),
                fake.date_between(start_date='-30d', end_date='today')
            ])
            count += 1

print("applications.csv done — 100 rows")

# ── 7. Feedback — 100 rows
with open('feedback.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['FeedbackID', 'StudentID', 'CompanyID',
                     'InternshipID', 'Rating', 'Comments'])
    for i in range(1, 101):
        writer.writerow([
            i,
            random.choice(student_ids),
            random.choice(company_ids),
            random.choice(internship_ids),
            random.randint(1, 5),
            fake.paragraph(nb_sentences=1)
        ])

print("feedback.csv done — 100 rows")

# ── 8. EligibilityCriteria — 100 rows (one per internship)
exp_levels = ['None', 'Beginner', 'Intermediate']

with open('eligibility_criteria.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['CriteriaID', 'InternshipID',
                     'MinCGPA', 'MinSemester', 'ExperienceLevel'])
    for i in internship_ids:
        writer.writerow([
            i, i,
            round(random.uniform(2.0, 3.5), 2),
            random.randint(3, 6),
            random.choice(exp_levels)
        ])

print("eligibility_criteria.csv done — 100 rows")

# ── 9. EligibleDepartments — 100+ rows
rows_written = 0
with open('eligible_departments.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['EligDeptID', 'InternshipID', 'DepartmentID'])
    count = 1
    for iid in internship_ids:
        num_depts = random.randint(1, 3)
        chosen = random.sample(dept_ids, num_depts)
        for did in chosen:
            writer.writerow([count, iid, did])
            count += 1
            rows_written += 1

print(f"eligible_departments.csv done — {rows_written} rows")

# ── 10. InternshipSkills — 100+ rows
skill_ids = [row[0] for row in skills_data]
rows_written = 0

with open('internship_skills.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['InternshipID', 'SkillID'])
    used = set()
    for iid in internship_ids:
        num_skills = random.randint(2, 4)
        chosen = random.sample(skill_ids, num_skills)
        for sid in chosen:
            if (iid, sid) not in used:
                used.add((iid, sid))
                writer.writerow([iid, sid])
                rows_written += 1

print(f"internship_skills.csv done — {rows_written} rows")

# ── 11. StudentSkills — 100+ rows
rows_written = 0

with open('student_skills.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['StudentID', 'SkillID'])
    used = set()
    for sid in student_ids:
        num_skills = random.randint(2, 5)
        chosen = random.sample(skill_ids, num_skills)
        for skid in chosen:
            if (sid, skid) not in used:
                used.add((sid, skid))
                writer.writerow([sid, skid])
                rows_written += 1

print(f"student_skills.csv done — {rows_written} rows")

print("\nAll CSV files generated successfully!")
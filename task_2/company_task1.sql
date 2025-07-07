create database company

use company
create schema hr

create table hr.Department(
Dname nvarchar(255) not null unique,
Dnum int identity(100,10) primary key,
loc nvarchar(255) 
)

create table hr.Employee(
ssn INT primary key not null,
Fname nvarchar(50) not null,
Lname nvarchar(50) not null,
gender char(1),
B_D date,
sup_ssn int,
Dnum int,
foreign key(Dnum) references hr.Department(Dnum) on delete set null on update cascade,
foreign key(sup_ssn) references hr.Employee(ssn)
)

create table hr.manage(
ssn int not null ,
Dnum int not null,
hire_date DATE not null,
foreign key(ssn) references hr.Employee(ssn)   ,
foreign key(Dnum) references hr.Department(Dnum)on delete cascade,
primary key(ssn,Dnum)
)

create table hr.Project (
Pnum int identity(1,1) primary key,
Pname nvarchar(255) unique,
cite nvarchar (255),
Dnum int ,
foreign key(Dnum) references hr.Department(Dnum) on delete cascade 
)

create table hr.work_on(
ssn int not null,
Pnum int not null,
working_hours decimal(4, 1)
foreign key(ssn) references hr.Employee(ssn)on delete no action,
foreign key(Pnum) references hr.Project(Pnum)on delete cascade ,
primary key(ssn,Pnum)
)

create table hr.dependant(
name nvarchar(255) not null ,
B_D date,
gender char(1),
emp_ssn int not null ,
foreign key(emp_ssn) references hr.Employee(ssn)on delete cascade,
primary key(emp_ssn,name)
)



-- Insert sample data into DEPARTMENT table
INSERT INTO hr.Department (Dname, loc) VALUES 
('Human Resources', 'Cairo '),
('Research and Development', 'Alexandria'),
('Finance', 'Giza'),
('Marketing', 'Sharm El Sheikh'),
('Tourism Operations', 'Aswan'),
('Nile Logistics', 'Mansoura'),
('Arabic Content', 'Tanta');

select *
from hr.Department;

-- Insert sample data into EMPLOYEE table
INSERT INTO hr.Employee (ssn, Fname, Lname, gender, B_D, sup_ssn, Dnum) VALUES
(102030405, 'Ahmed', 'Mohamed', 'M', '1985-08-15', null, 100),
(203040506, 'Mariam', 'Ali', 'F', '1990-11-22', 102030405, 100),
(304050607, 'Mahmoud', 'Hassan', 'M', '1988-04-03', 102030405, 110),
(405060708, 'Aya', 'Ibrahim', 'F', '1992-09-18', null , 110),
(506070809, 'Omar', 'Kamel', 'M', '1995-01-25', 405060708, 120);


select *
from hr.Employee;

--Update an employee's department

update hr.Employee set Dnum=100 where ssn=304050607;
update hr.Employee set Dnum=110 where ssn=506070809;

select *
from hr.Employee;



-- Insert sample data into dependant table
INSERT INTO hr.dependant (name, B_D, gender, emp_ssn) VALUES
('Youssef Ahmed', '2015-07-12', 'M', 102030405),
('Fatma Mariam', '2018-02-28', 'F', 203040506),
('Kareem Mahmoud', '2016-05-14', 'M', 304050607),
('Lina Aya', '2019-12-03', 'F', 405060708),
('Ziad Omar', '2020-08-20', 'M', 506070809);

select *
from hr.dependant;

--Delete a dependent record
delete from hr.dependant where emp_ssn= 102030405;

select *
from hr.dependant;

--Retrieve all employees working in a specific department
select * 
from hr.Employee
where Dnum =100;


-- Insert sample data into manage table
INSERT INTO hr.manage (ssn, Dnum, hire_date) VALUES
(102030405, 100, '2016-01-15'),
(405060708, 110, '2020-06-20');

select *
from hr.manage;

-- Insert sample data into Project table
INSERT INTO hr.Project (Pname, cite, Dnum) VALUES
('Nile Cruise Booking System', 'Aswan', 150),
('Website Redesign', 'Tanta', 160),
('Financial System', 'Cairo', 100),
('Network Upgrade', 'Giza', 110);

select *
from hr.Project;

-- Insert sample data into work_on table
INSERT INTO hr.work_on (ssn, Pnum, working_hours) VALUES
(102030405, 1, 35.5),
(203040506, 2, 40.0),
(304050607, 3, 25.5),
(405060708, 4, 30.0);

select *
from hr.work_on;

--Find all employees and their project assignments with working hours

select E.* ,p.Pname as project_name,W.working_hours
from hr.Employee E
LEFT JOIN
    hr.work_on AS W ON E.ssn = W.ssn
LEFT JOIN
    hr.Project AS p ON W.Pnum = p.PNum




-------------------------------------------------------------------

ALTER TABLE hr.Employee ADD Email NVARCHAR(100);

ALTER TABLE hr.Employee ALTER COLUMN Fname NVARCHAR(255);

ALTER TABLE hr.Employee ADD salary  DECIMAL(10,2) CHECK (Salary >= 3000) DEFAULT 3000 ;
select * 
from hr.Employee;

update hr.Employee set salary = 14000.00 where Dnum=100;

select * 
from hr.Employee;

update hr.Employee set salary = 16000 where Dnum=110;

select * 
from hr.Employee;


INSERT INTO hr.Department (Dname, loc) VALUES
('IT and Digital Transformation', 'New Cairo'),
('Sales and Marketing', 'Alexandria'),
('Customer Relations', 'Mansoura'),
('Quality Assurance', 'Tanta'),
('Public Relations', 'Zamalek');


select * 
from hr.Department ;

INSERT INTO hr.Employee (ssn, Fname, Lname, gender, B_D, Dnum, Email, salary, sup_ssn) VALUES
(102030480, 'Khaled', 'ahmed', 'M', '1982-05-20', 100, 'khaled.masry@company.com', 25000.00, NULL),        -- IT Manager
(102030481, 'Fatma', 'Ali', 'F', '1995-03-15', 100, 'fatma.ali@company.com', 14000.00, 102030480),
(102030780, 'Amr', 'mohamed', 'M', '1998-07-22', 100, 'amr.diab@company.com', 13500.00, 102030480),
(102030804, 'Mona', 'ali', 'F', '1985-11-02', 110, 'mona.zaki@company.com', 28000.00, NULL),                -- Sales Director
(102030805, 'Ahmed', 'karam', 'M', '1992-09-18', 110, 'ahmed.helmy@company.com', 16000.00, 102030804),
(102030806, 'Yasmine', 'hany', 'F', '1990-01-30', 120, 'yasmine.a@company.com', 22000.00, 102030804),         
(102030907, 'Tamer', 'ali', 'M', '1988-09-12', 130, 'tamer.hosny@company.com', 26000.00, NULL),             -- Tourism Manager
(102037898, 'Sherine', 'ahmed', 'F', '1999-05-18', 130, 'sherine.aw@company.com', 12000.00, 102030804),
(102037419, 'Karim', 'mahmoud', 'M', '1991-12-01', 150, 'karim.fahmy@company.com', 24000.00, NULL),             -- Finance Manager
(102030456, 'Donia', 'ali', 'F', '1993-08-14', 160, 'donia.samir@company.com', 19000.00, NULL);             -- Customer Relations Manager


select * 
from hr.Employee;

INSERT INTO hr.manage (ssn, Dnum, hire_date) VALUES
(102030480, 170, '2019-01-15'), -- Khaled manages IT
(102030804, 180, '2020-02-20'), -- Mona manages Sales and Marketing
(102030907, 140, '2018-06-01'), -- Tamer manages Tourism Operations
(102037419, 120, '2019-11-25'), -- Karim manages Finance
(102030456, 190, '2022-01-30'); 

select * 
from hr.manage ;



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

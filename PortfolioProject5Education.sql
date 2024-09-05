--Portfolio Project 5: Creating and Querying a School mgt system
--Description: This SQL Project carried out involves the Creation and manpiulation of a Education Database containing 4 tables,
-- populating the tables, and querying the data in the tables to provide insights for the compay and help them make 
--informed decisions.

-- Create the database
CREATE DATABASE EducationStudentDb;
GO

-- Use the database
USE EducationStudentDb;
GO

-- Create the Student table
CREATE TABLE Student (
    StudentID NVARCHAR(10) PRIMARY KEY,
    StudentName NVARCHAR(100),
    Age INT,
    ClassID INT ,
    StateID INT
);
GO

-- Create the ClassMaster table
CREATE TABLE ClassMaster (
    ClassID INT PRIMARY KEY,
    ClassName NVARCHAR(50),
    TeacherID NVARCHAR(10) 
);
GO

-- Create the TeacherMaster table
CREATE TABLE TeacherMaster (
    TeacherID NVARCHAR(10) PRIMARY KEY,
    TeacherName NVARCHAR(100),
    Subject NVARCHAR(50)
);
GO

-- Create the Statemaster table
CREATE TABLE Statemaster (
    StateID INT PRIMARY KEY,
    StateName NVARCHAR(50)
);
GO

-- Insert data into the Statemaster table
INSERT INTO Statemaster (StateID, StateName)
VALUES 
(101, 'Lagos'),
(102, 'Abuja'),
(103, 'Kano'),
(104, 'Delta'),
(105, 'Ido'),
(106, 'Ibadan'),
(107, 'Enugu'),
(108, 'Kaduna'),
(109, 'Ogun'),
(110, 'Anambra');
GO

-- Insert data into the TeacherMaster table
INSERT INTO TeacherMaster (TeacherID, TeacherName, Subject)
VALUES
('T01', 'Mr. Johnson', 'Mathematics'),
('T02', 'Ms. Smith', 'Science'),
('T03', 'Mr. Williams', 'English'),
('T04', 'Ms. Brown', 'History');
GO

-- Insert data into the ClassMaster table
INSERT INTO ClassMaster (ClassID, ClassName, TeacherID)
VALUES
(1, '10th Grade', 'T01'),
(2, '9th Grade', 'T02'),
(3, '11th Grade', 'T03'),
(4, '12th Grade', 'T04');
GO

-- Insert data into the Student table
INSERT INTO Student (StudentID, StudentName, Age, ClassID, StateID)
VALUES
('S01', 'Alice Brown', 16, 1, 101),
('S02', 'Bob White', 15, 2, 102),
('S03', 'Charlie Black', 17, 3, 103),
('S04', 'Daisy Green', 16, 4, 104),
('S05', 'Edward Blue', 14, 1, 105),
('S06', 'Fiona Red', 15, 2, 106),
('S07', 'George Yellow', 18, 3, 107),
('S08', 'Hannah Purple', 16, 4, 108),
('S09', 'Ian Orange', 17, 1, 109),
('S10', 'Jane Grey', 14, 2, 110);
GO


/*SQL Tasks:
1.	Fetch students with the same age.
2.	Find the second youngest student and their class and teacher.
3.	Get the maximum age per class and the student name.
4.	Teacher-wise count of students sorted by count in descending order.
5.	Fetch only the first name from the StudentName and append the age.
6.	Fetch students with odd ages.
7.	Create a view to fetch student details with an age greater than 15.
8.	Create a procedure to update the student's age by 1 year where the class is '10th Grade' and the teacher is not 'Mr. Johnson'.
*/

--Queries
--1.	Fetch students with the same age.
select StudentName,count(Age) 
from Student
group by StudentName
having count(Age) > 1

--2.	Find the second youngest student and their class and teacher.
select S.StudentName, S.Age, T.TeacherName
from Student S
join ClassMaster C on C.ClassID = S.ClassID
join TeacherMaster T on T.TeacherID = C.TeacherID
order by Age desc
Offset 1 row
fetch next 1 row only

--3.	Get the maximum age per class and the student name.
select S.StudentName, C.ClassName, S.Age 
from Student S
join ClassMaster C on C.ClassID = S.ClassID
join (select ClassID, max(Age) Max_age
from Student S
group by ClassID) D
on S.ClassID = D.ClassID
and S.Age = D.Max_age

--4.	Teacher-wise count of students sorted by count in descending order.
select T.TeacherName,  count(S.StudentName) No_of_students
from Student S
join ClassMaster C on C.ClassID = S.ClassID
join TeacherMaster T on T.TeacherID = C.TeacherID
group by T.TeacherName
order by count(S.StudentName) desc

--5.	Fetch only the first name from the StudentName and append the age.

select CONCAT(left(StudentName, Charindex(' ',StudentName) -1 ), '_' , Age) Studentname_Age
from Student

--6.	Fetch students with odd ages.
select * from Student
where Age % 2 =1

--7.	Create a view to fetch student details with an age greater than 15.
create view vw_OlderStudents as
select * from Student
where age> 15

--8.	Create a procedure to update the student's age by 1 year where the class is '10th Grade' and the teacher is not 'Mr. Johnson'.
create procedure SP_StudentAgeUpdate as
begin
update S
set S.Age = S.Age + 1
from Student S
join ClassMaster C on C.ClassID = S.ClassID
join TeacherMaster T on T.TeacherID = C.TeacherID
where ClassName = '10th Grade' and TeacherName != 'Mr. Johnson'
end
go

exec [dbo].[SP_StudentAgeUpdate]


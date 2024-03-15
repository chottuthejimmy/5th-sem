-- Program: Consider the schema for Company Database:

-- EMPLOYEE(SSN, Name, Address, Sex, Salary, SuperSSN, DNo)

-- DEPARTMENT(DNo, DName, MgrSSN, MgrStartDate)

-- DLOCATION(DNo,DLoc)

-- PROJECT(PNo, PName, PLocation, DNo)

-- WORKS_ON(SSN, PNo, Hours)

create table DEPARTMENT(DNo int primary key, DName varchar(20), MgrStartDate date);

create table EMPLOYEE(SSN int primary key, FName varchar(20), LName varchar(20), Address varchar(20), Sex char(1), Salary real, SuperSSN int, DNo int, foreign key(DNo) references DEPARTMENT(DNo), foreign key(SuperSSN) references EMPLOYEE(SSN));

alter table DEPARTMENT add MgrSSN varchar(10) references EMPLOYEE(SSN);

create table DLOCATION(DNo int, DLoc varchar(20), primary key(DNo, DLoc), foreign key(DNo) references DEPARTMENT(DNo));

create table PROJECT(PNo int primary key, PName varchar(20), PLocation varchar(20), DNo int, foreign key(DNo) references DEPARTMENT(DNo));

create table WORKS_ON(SSN int, PNo int, Hours int, primary key(SSN, PNo), foreign key(SSN) references EMPLOYEE(SSN), foreign key(PNo) references PROJECT(PNo));

```
 insert into EMPLOYEE(SSN, FName, LName, Address, Sex, Salary) values
    (1,"A","Scott","C",'M',1000),
    (2,"D","E","F",'F',2000),
    (3,"G","H","I",'M',3000);

insert into DEPARTMENT values(1,"A","2020-01-01", 1);
insert into DEPARTMENT values(2,"B","2020-01-01", 2);
insert into DEPARTMENT values(3,"C","2020-01-01", 3);

update Employee set SuperSSN = 1, DNo = 1 where SSN = 2;
update Employee set SuperSSN = 2, DNo = 2 where SSN = 3;
update Employee set SuperSSN = 3, DNo = 3 where SSN = 1;

insert into DLOCATION values(1,"BANGLORE");
insert into DLOCATION values(2,"MYSORE");
insert into DLOCATION values(3,"MANGLORE");

insert into PROJECT values(1,"P","BANGLORE",1);
insert into PROJECT values(2,"Q","MYSORE",2);
insert into PROJECT values(3,"R","MANGLORE",3);

insert into WORKS_ON values(1,1,10);
insert into WORKS_ON values(2,2,20);
insert into WORKS_ON values(3,3,30)
```

-- 1. Make a list of all project numbers for projects that involve an employee whose last name is ‘Scott’, either as a worker or as a manager of the department that controls the project.

select distinct PNo from WORKS_ON natural join EMPLOYEE natural join DEPARTMENT natural join PROJECT where LName = "Scott" or MgrSSN = SSN;

-- 2. Show the resulting salaries if every employee working on the ‘IoT’ project is given a 10 percent raise.

update EMPLOYEE set Salary = Salary * 1.1 where SSN in (select SSN from WORKS_ON where PNo in (select PNo from PROJECT where PName = "IoT"));

select FName, Salary from EMPLOYEE where SSN in (select SSN from WORKS_ON where PNo in (select PNo from PROJECT where PName = "IoT"));

-- 3. Find the sum of the salaries of all employees of the ‘Accounts’ department, as well as the maximum salary, the minimum salary, and the average salary in this department

select sum(Salary), max(Salary), min(Salary), avg(Salary) from EMPLOYEE where DNo in (select DNo from DEPARTMENT where DName = "Accounts");

-- 4. Retrieve the name of each employee who works on all the projects controlled by department number 5 (use NOT EXISTS operator).

select FName from EMPLOYEE where not exists (select PNo from PROJECT where DNo = 5 except select PNo from WORKS_ON where SSN = EMPLOYEE.SSN);

-- 5. For each department that has more than five employees, retrieve the department number and the number of its employees who are making more than Rs.6,00,000.

select DNo, count(*) as "Number of Employees" from EMPLOYEE where Salary > 600000 group by DNo having count(*) > 5;

-- Program: Consider the schema for College Database:

-- STUDENT(USN, SName, Address, Phone, Gender)

-- SEMSEC(SSID, Sem, Sec)

-- CLASS(USN, SSID)

-- COURSE(Subcode, Title, Sem, Credits)

-- IAMARKS(USN, Subcode, SSID, Test1, Test2, Test3, FinalIA)

-- Write SQL queries to
-- 1. List all the student details studying in fourth semester ‘C’ section.
-- 2. Compute the total number of male and female students in each semester and in each section.
-- 3. Create a view of Test1 marks of student USN ‘1BI15CS101’ in all Courses.
-- 4. Calculate the FinalIA (average of best two test marks) and update the corresponding table for all students.
-- 5. Categorize students based on the following criterion:
-- If FinalIA = 17 to 20 then CAT = ‘Outstanding’
-- If FinalIA = 12 to 16 then CAT = ‘Average’
-- If FinalIA< 12 then CAT = ‘Weak’
-- Give these details only for 8th semester A, B, and C section students.

Create table STUDENT(USN varchar(20) primary key, SName varchar(20), Address varchar(20), Phone real, Gender char(1));

Create table SEMSEC(SSID int primary key, Sem int, Sec char(1));

Create table CLASS(USN varchar(20), SSID int, primary key(USN, SSID), foreign key(USN) references STUDENT(USN), foreign key(SSID) references SEMSEC(SSID));

Create table COURSE(Subcode varchar(10) primary key, Title varchar(20), Sem int, Credits int);

Create table IAMARKS(USN varchar(20), Subcode varchar(10), SSID int, Test1 int, Test2 int, Test3 int, FinalIA int, primary key(USN, Subcode, SSID), foreign key(USN) references STUDENT(USN), foreign key(Subcode) references COURSE(Subcode), foreign key(SSID) references SEMSEC(SSID));

```
insert into STUDENT values("1BI15CS101","A","B",123,"M");
insert into STUDENT values("1BI15CS102","C","D",456,"F");
insert into STUDENT values("1BI15CS103","E","F",789,"M");

insert into SEMSEC values(1,4,"C");
insert into SEMSEC values(2,4,"A");
insert into SEMSEC values(3,4,"B");

insert into CLASS values("1BI15CS101",1);
insert into CLASS values("1BI15CS102",2);
insert into CLASS values("1BI15CS103",3);

insert into COURSE values("CS101","A",4,4);
insert into COURSE values("CS102","B",4,4);
insert into COURSE values("CS103","C",4,4);

insert into IAMARKS (USN, Subcode, SSID, Test1, Test2, Test3) values("1BI15CS101","CS101",1,10,20,30), ("1BI15CS101","CS102",1,40,50,60), ("1BI15CS101","CS103",1,70,80,90);
```

-- 1. List all the student details studying in fourth semester ‘C’ section.

select * from STUDENT natural join CLASS natural join SEMSEC where Sem = 4 and Sec = "C";

-- 2. Compute the total number of male and female students in each semester and in each section.

select Sem, Sec, Gender, count(*) as Total 
from STUDENT natural join CLASS natural join SEMSEC 
group by Sem, Sec, Gender order by Sem, Sec;

-- 3. Create a view of Test1 marks of student USN ‘1BI15CS101’ in all Courses.

create view Test1Marks as select Subcode, Test1 from IAMARKS where USN = "1BI15CS101";

-- 4. Calculate the FinalIA (average of best two test marks) and update the corresponding table for all students.

update IAMARKS set FinalIA = (Test1 + Test2 + Test3 - least(Test1, Test2, Test3)) / 2;

-- 5. Categorize students based on the following criterion:
-- If FinalIA = 17 to 20 then CAT = ‘Outstanding’
-- If FinalIA = 12 to 16 then CAT = ‘Average’
-- If FinalIA< 12 then CAT = ‘Weak’
-- Give these details only for 8th semester A, B, and C section students.

select USN, Sem, Sec, case when FinalIA between 17 and 20 then "Outstanding" when FinalIA between 12 and 16 then "Average" else "Weak" end as CAT from IAMARKS natural join CLASS natural join SEMSEC where Sem = 8 and Sec in ("A", "B", "C");

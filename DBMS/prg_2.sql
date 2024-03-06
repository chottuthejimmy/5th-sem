-- Order Database

-- SALESMAN(Salesman_id, Name, City, Commission)

-- CUSTOMER(Customer_id, Cust_Name, City, Grade, Salesman_id)

-- ORDERS(Ord_No, Purchase_Amt, Ord_Date, Customer_id, Salesman_id)

create table SALESMAN(
    Salesman_id int primary key,
    Name varchar(20),
    City varchar(20),
    Commission real
);

create table CUSTOMER(
    Customer_id int primary key,
    Cust_Name varchar(20),
    City varchar(20),
    Grade int,
    Salesman_id int,
    foreign key (Salesman_id) references SALESMAN(Salesman_id) on delete set null
);

create table ORDERS(
    Ord_No int primary key,
    Purchase_Amt real,
    Ord_Date date,
    Customer_id int,
    Salesman_id int,
    foreign key (Customer_id) references CUSTOMER(Customer_id),
    foreign key (Salesman_id) references SALESMAN(Salesman_id) on delete cascade
);

```
insert into SALESMAN values(1,"A","Bangalore",0.1);
insert into SALESMAN values(2,"B","Delhi",0.2);
insert into SALESMAN values(3,"C","Mumbai",0.3);

insert into CUSTOMER values(1,"X","Bangalore",1,1);
insert into CUSTOMER values(4,"A","Bangalore",2,1);
insert into CUSTOMER values(2,"Y","Delhi",2,2);
insert into CUSTOMER values(3,"Z","Mumbai",3,3);

insert into ORDERS values(1,1000,"2020-01-01",1,1);
insert into ORDERS values(2,2000,"2020-01-02",2,2);
insert into ORDERS values(3,3000,"2020-01-03",3,3);
```
-- 1. Count the customers with grades above Bangalore’s average.

select count(*) from CUSTOMER where Grade > (select avg(Grade) from CUSTOMER where City = "Bangalore");

-- 2. Find the name and numbers of all salesman who had more than one customer.

select Name, count(*) from SALESMAN natural join CUSTOMER group by Salesman_id having count(*) > 1;

-- 3. List all the salesman and indicate those who have and don’t have customers in their cities (Use UNION operation.)

(select S.Salesman_id, Name, Cust_Name from SALESMAN S, customer C where S.city = C.city)
 union
 (select Salesman_id, Name, 'NO MATCH' from SALESMAN where NOT city = any (select City from CUSTOMER)) order by 2 desc;

-- 4. Create a view that finds the salesman who has the customer with the highest order of a day.

create view V as (select Salesman_id, Name, Ord_Date from SALESMAN natural join ORDERS natural join CUSTOMER where Purchase_Amt = (select max(Purchase_Amt) group by Ord_Date));

-- 5. Demonstrate the DELETE operation by removing salesman with id 1000. All his orders must also be deleted.

delete from SALESMAN where Salesman_id = 1000;

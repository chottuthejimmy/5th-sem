-- Library Database

-- BOOK(Book_id, Title, Publisher_Name, Pub_Year)

-- BOOK_AUTHORS(Book_id, Author_Name)

-- PUBLISHER(Name, Address, Phone)

-- BOOK_COPIES(Book_id, Programme_id, No-of_Copies)

-- BOOK_LENDING(Book_id, Programme_id, Card_No, Date_Out, Due_Date)

-- LIBRARY_PROGRAMME(Programme_id, Programme_Name, Address)



create table PUBLISHER(
    Name varchar(20) primary key,
    Address varchar(20),
    Phone real
);


create table BOOK(
    Book_id int primary key,
    Title varchar(10),
    Publisher_Name varchar(20),
    Pub_Year int,
    foreign key (Publisher_Name) references PUBLISHER(Name) on delete cascade
);

create table BOOK_AUTHORS(
    Book_id int,
    Author_Name varchar(20),
    primary key (Book_id, Author_Name),
    foreign key (Book_id) references BOOK(Book_id) on delete cascade
);

create table LIBRARY_PROGRAMME(
    Programme_id int primary key,
    Programme_Name varchar(20),
    Address varchar(20)
);

create table BOOK_COPIES(
    Book_id int,
    Programme_id int,
    No_of_Copies int,
    primary key (Book_id, Programme_id),
    foreign key (Book_id) references BOOK(Book_id) on delete cascade,
    foreign key (Programme_id) references LIBRARY_PROGRAMME(Programme_id) on delete cascade
);

create table BOOK_LENDING(
    Book_id int,
    Programme_id int,
    Card_No int,
    Date_Out date,
    Due_Date date,
    primary key (Book_id, Programme_id, Card_No),
    foreign key (Book_id) references BOOK(Book_id) on delete cascade,
    foreign key (Programme_id) references LIBRARY_PROGRAMME(Programme_id) on delete cascade
);


```
INSERT INTO PUBLISHER VALUES("PEARSON","Bombay","8797546021");
INSERT INTO PUBLISHER VALUES("MCGRAW HILL","Delhi","8797546021");
INSERT INTO PUBLISHER VALUES("WILEY","Bangalore","8797546021");

INSERT INTO BOOK VALUES(1,"C++","PEARSON",2010);
INSERT INTO BOOK VALUES(2,"JAVA","MCGRAW HILL",2011);
INSERT INTO BOOK VALUES(3,"PYTHON","WILEY",2012);

INSERT INTO BOOK_AUTHORS VALUES(1,"YASHWANT KANETKAR");
INSERT INTO BOOK_AUTHORS VALUES(2,"HERBERT SCHILDT");
INSERT INTO BOOK_AUTHORS VALUES(3,"MARK LUTZ");

INSERT INTO LIBRARY_PROGRAMME VALUES(1,"IIT","Delhi");
INSERT INTO LIBRARY_PROGRAMME VALUES(2,"IIM","Bangalore");
INSERT INTO LIBRARY_PROGRAMME VALUES(3,"NIT","Bombay");

INSERT INTO BOOK_COPIES VALUES(1,1,10);
INSERT INTO BOOK_COPIES VALUES(2,2,20);
INSERT INTO BOOK_COPIES VALUES(3,3,30);

INSERT INTO BOOK_LENDING VALUES(1,1,1,"2017-01-01","2017-01-10");
INSERT INTO BOOK_LENDING VALUES(2,2,2,"2017-02-01","2017-02-10");
INSERT INTO BOOK_LENDING VALUES(3,3,3,"2017-08-01","2017-09-10");
```

-- Retrieve details of all books in the library_ id, title, name of publisher, authors, number of copies in each branch, etc.

select publisher_name, title, author_name, no_of_copies from book natural join book_authors natural join book_copies;

-- Get the particulars of borrowers who have borrowed more than 3 books, but from Jan 2017 to Jun 2017.

select card_no from book_lending where date_out between '2017-01-01' and '2017-06-30' group by card_no having count(*) > 3;

-- Delete a book in BOOK table, Update the contents of other tables to reflect this data manipulation Operation.

delete from book where book_id = 1;

-- Partition the BOOK table based on year of publication. Demonstrate its working with a simple query

create view book_2010 as select * from book where pub_year = 2010;

-- Create a view of all books and its number of copies that are currently available in the Library

create view available_books as select book_id, title, no_of_copies from book natural join book_copies where no_of_copies > 0;

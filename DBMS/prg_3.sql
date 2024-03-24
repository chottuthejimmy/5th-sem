-- Program: Consider the schema for Movie Database:

-- ACTOR(Act_id, Act_Name, Act_Gender)

-- DIRECTOR(Dir_id, Dir_Name, Dir_Phone)

-- MOVIES(Mov_id, Mov_Title, Mov_Year, Mov_Lang, Dir_id)

-- MOVIE_CAST(Act_id, Mov_id, Role)

-- RATING(Mov_id, Rev_Stars)

create table ACTOR(
    Act_id int primary key, 
    Act_Name varchar(20), 
    Gender char(1));

create table DIRECTOR(
    Dir_id int primary key, 
    Dir_Name varchar(20), 
    Dir_Phone real);

create table MOVIES(
    Mov_id int primary key, 
    Mov_Title varchar(20), 
    Mov_Year int, 
    Mov_Lang char(20), 
    Dir_id int, 
    foreign key(Dir_id) references DIRECTOR(Dir_id));

create table MOVIE_CAST(
    Act_id int, 
    Mov_id int, 
    Role char(20),
    primary key(Act_id, Mov_id),
    foreign key(Act_id) references ACTOR(Act_id),
    foreign key(Mov_id) references MOVIES(Mov_id));

create table RATING(
    Mov_id int not null, 
    Rev_Stars int,
    foreign key(Mov_id) references MOVIES(Mov_id));

```
insert into ACTOR values(1,"A",'M');
insert into ACTOR values(2,"B",'F');
insert into ACTOR values(3,"C",'M');

insert into DIRECTOR values(1,"Hitchcock",123);
insert into DIRECTOR values(2,"Steven Spielberg",456);
insert into DIRECTOR values(3,"Z",789);

insert into MOVIES values(1,"P",1999,"English",1);
insert into MOVIES values(2,"Q",2017,"Hindi",2);
insert into MOVIES values(3,"R",2002,"English",3);

insert into MOVIE_CAST values(1,1,"Lead");
insert into MOVIE_CAST values(1,2,"Supporting");
insert into MOVIE_CAST values(3,3,"Lead");

insert into RATING values(1,5);
insert into RATING values(1,4);
insert into RATING values(2,4);
insert into RATING values(3,3);
```

-- 1. List the titles of all movies directed by ‘Hitchcock’.

select Mov_Title from MOVIES natural join DIRECTOR where Dir_Name = "Hitchcock"; 

-- 2. Find the movie names where one or more actors acted in two or more movies.

select distinct Mov_Title from MOVIES m, MOVIE_CAST mc where m.Mov_id = mc.Mov_id and Act_id in (select Act_id from MOVIE_CAST group by Act_id having count(*) > 1);

-- 3. List all actors who acted in a movie before 2000 and also in a movie after 2015(use JOIN operation).

select Act_Name from ACTOR natural join MOVIE_CAST natural join MOVIES where Mov_Year not between 2000 and 2015;

SELECT DISTINCT A.Act_id, A.Act_Name
FROM ACTOR A
JOIN MOVIE_CAST MC1 ON A.Act_id = MC1.Act_id
JOIN MOVIES M1 ON MC1.Mov_id = M1.Mov_id AND M1.Mov_Year < 2000
JOIN MOVIE_CAST MC2 ON A.Act_id = MC2.Act_id
JOIN MOVIES M2 ON MC2.Mov_id = M2.Mov_id AND M2.Mov_Year > 2015;

-- 4. Find the title of movies and number of stars for each movie that has at least one rating and find the highest number of stars that movie received. Sort the result by movie title.

select Mov_Title, max(Rev_Stars) from MOVIES natural join RATING group by Mov_Title having max(Rev_Stars) > 0 order by Mov_Title;

-- 5. Update rating of all movies directed by ‘Steven Spielberg’ to 5.

update RATING set Rev_Stars = 5 where Mov_id in (select Mov_id from MOVIES where Dir_id in (select Dir_id from DIRECTOR where Dir_Name = "Steven Spielberg"));

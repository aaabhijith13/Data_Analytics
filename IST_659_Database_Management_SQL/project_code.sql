SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
 
if not exists (select * from sys.databases where name = 'project_659')
    create database project_659
go

use project_659 
go

-- DOWN
drop table if exists employees
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_reservations_reservation_book_id')
    alter table reservations drop constraint fk_reservations_reservation_book_id
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_reservations_reservation_member_id')
    alter table reservations drop constraint fk_reservations_reservation_member_id
drop table if exists reservations 
drop table if exists members 

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_book_authors_book_author_author_id')
    alter table book_authors drop constraint fk_book_authors_book_author_author_id
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_book_authors_book_author_book_id')
    alter table book_authors drop constraint fk_book_authors_book_author_book_id
drop table if exists book_authors 
drop table if exists writers
drop table if exists books
GO 

-- UP Metadata
create table books (
    book_id int not null,
    book_title varchar(50) not null,
    book_category_name varchar(50) not null,
    book_status varchar(50) not null,
    constraint pk_books_book_id primary key (book_id)
)

create table writers (
    writer_id int identity not null,
    writer_first_name varchar(50) not null,
    writer_last_name varchar(50) not null,
    constraint pk_writers_writer_id primary key (writer_id)    
)

create table book_authors (
    book_author_book_id int not null,
    book_author_author_id int not null,
)
alter table book_authors 
    add constraint fk_book_authors_book_author_book_id foreign key (book_author_book_id)
    references books(book_id)
alter table book_authors  
    add constraint fk_book_authors_book_author_author_id foreign key (book_author_author_id)
    references writers(writer_id)

create table members(
    member_id int identity not null,
    member_firstname varchar(50) not null,
    member_lastname varchar(50) null,
    member_joined_date date not null,
    member_active_status varchar(50) not null,
    member_email_address varchar(50) null,
    member_address varchar(50) null,
    constraint pk_members_member_id primary key (member_id),
    constraint u_members_member_id unique (member_email_address),
    constraint u_members_memeber_adress unique (member_address)
)

create table reservations (
    reservation_id int identity not null,
    reservation_member_id int not null,
    reservation_book_id int not null,
    reservation_date date not null,
    reservation_return_date date not null,
    constraint pk_reservations_reservation_id primary key (reservation_id)
)
alter table reservations 
    add constraint fk_reservations_reservation_member_id foreign key (reservation_member_id)
        references members(member_id)
alter table reservations
    add constraint fk_reservations_reservation_book_id foreign key(reservation_book_id)
        references books(book_id)

create table employees (
    employee_id int identity not null,
    employee_ssn int not null, 
    employee_firstname varchar(50) not null, 
    employee_lastname varchar(50) not null,
    employee_email varchar(50) not null,
    employee_hiredate date not null,
    employee_termdate date null,
    employee_jobtitle varchar(50) not null,
    employee_department varchar(50) not null,
    employee_payrate money null,
    employee_department_head varchar(50) not null,
    employee_hours_worked int null,
    employee_pay_date date not null,
    constraint pk_employees_employee_id primary key (employee_id),
    constraint u_employees_employee_ssn unique (employee_ssn)
)
GO 

--UP Data
insert into books (book_id, book_title, book_category_name, book_status) 
values
(1, 'Jianghui','Fiction', 'Available'), --1
(2, 'Crocodile','Non-Fiction', 'Not Available'), --2
(3, 'Snakes','Comic', 'Available'), --3
(4, 'Kangaroo','Fiction', 'Not Available'), --4
(5, 'Oh Life ','Non-Fiction', 'Available'), --5
(6, 'Giorgio Amarni','Fiction', 'Not Available'), --6
(7, 'Oh Jojo ','Non-Fiction', 'Available'), --7
(8, 'Jujutsu Kaisen', 'Fiction', 'Available'),--8
(9, 'Haikyuu', 'Fiction', 'Available'), --9
(10, 'Death Note' , 'Fiction', 'Available'), -- 10
(11, 'How to start your own business', 'Textbook', 'Available'), --11
(12, 'SQL for dummies', 'Textbook', 'Not Available'), --12
(13, 'Course of Theoretical Physics', 'Textbook', 'Available'), --13
(14, 'An introduction to statistical infernce', 'Textbook', 'Available'), --14
(15, 'Python for everybody','Textbook', 'Available'), --15
(16, 'Life of Pi', 'Action and Adventure', 'Not Available'), --16
(17, 'The Three Musketeers', 'Action and Adventure', 'Not Available'), --17
(18, 'The Call of the Wild', 'Action and Adventure', 'Available'), --18
(19, 'Watchmen', 'Comic', 'Not Available') --19


insert into writers (writer_first_name, writer_last_name) 
values
('Maxwell','Guy'),--1
('Stephen','Rieks'),--2
('Mike','White'),--3
('Emily','Burrows'),--4
('Angela','Samson'),--5
('Rosie','loski'),--6
('Sean','Michaels'),--7
('Olivia','Jameson'),--8
('Samuel', 'Jackson'),--9
('Robert', 'Stew'),--10
('Bob', 'Builder'),--11
('Mackenzie', 'Rowe'),--12
('Abhijith', 'Vamadev'),--13
('Trina', 'Trisha'),--14
('Balthazar', 'Necromancer'),--15
('Shniua', 'Legal'),--16
('Lee', 'Sichuan'),--17
('Michael', 'Fudge'),--18
('Jayce', 'Talis'), --19
('Shauna', 'Vayne')--20


insert into book_authors(book_author_book_id, book_author_author_id)
values 
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 2),
(6, 3),
(7, 4),
(7, 5),
(7, 6),
(7, 7),
(7, 8),
(8, 2),
(9, 3),
(10, 4),
(10, 5),
(10, 1),
(11, 4),
(12, 5),
(12, 6),
(12, 7),
(12, 9),
(13, 14),
(13, 13),
(13, 12),
(14, 20),
(14, 19),
(15, 15),
(16, 16),
(17, 1),
(17, 17),
(18, 10),
(18, 18),
(19, 11),
(19, 9),
(19, 10),
(19, 8)
go 


insert into members (member_firstname, member_lastname, member_joined_date, member_active_status, member_email_address, member_address)
values 
('Abhijith', 'Vamadev', '2020-05-01', 'Active', 'aavamadev@syr.edu', 'Syracuse University'),
('Arsh', 'Singh', '2020-06-02', 'Active', 'arsh@syr.edu', 'Purdue University'),
('Jeffrey', 'Wong', '2020-01-04', 'Active', 'wong@purdue.edu', 'NorthWestern University'),
('Violet', 'Caitlin', '2020-09-15', 'Active', 'violetcaitlin@gmail.com', 'Zaun 201 Street'),
('Jayce', 'Tallis', '2020-10-13', 'Not-Active', 'jaycetallis@gmail.com', 'Magicland 202 Street'),
('Jinx','', '2020-10-15', 'Not-Active', 'jinxcrazy@gmail.com', 'Crazyland 2020 Street' ),
('Himerdinger', '', '2020-10-10', 'Active', 'councilor@gmail.com', 'Upperandlower 201 Street'),
('Caitlin', 'Kirreman', '2020-05-10', 'Active', 'cupcake@gmail.com', 'Piltover 2021 Street'),
('Viktor', 'Evolution', '2020-02-20', 'Active', 'thegreatestevolution@gmail.com', 'LowerCity 202 Street'),
('Akali', 'Tethi', '2019-05-19', 'Not-Active', 'fistofshadow@gmail.com', 'Kinko Order Street'),
('Irelia', 'Firremen', '2019-06-01', 'Active', 'bladedancer@hotmail.com', 'Navori Ionia 505 Street'),
('Draven', 'Darius', '2020-05-05', 'Not-Active', 'itsdraventime@hotmail.com', 'Noxus 200 Street'),
('Shauna', 'Vayne', '2020-02-20', 'Active', 'tumblecity@gmail.com', 'Tumble place 202 street'),
('Master', 'Yi', '2020-03-19', 'Not-Active', 'runfast@yahoo.com', '300 University Avenue'),
('Mel','', '2019-05-20', 'Active', 'influencer@gmail.com', 'Garudian 2020 Navel Place')
go 

insert into reservations(reservation_member_id, reservation_book_id, reservation_date, reservation_return_date)
values 
(1, 1, '2020-03-03', '2020-05-03'),
(1, 3, '2020-03-03', '2020-05-03'),
(2, 3, '2020-06-09', '2020-09-09'),
(3, 18, '2020-05-03', '2020-08-03'),
(3, 8, '2020-05-03', '2020-08-03'),
(4, 13, '2020-01-01', '2020-04-01'),
(5,11, '2020-05-03', '2020-08-03'),
(6, 14, '2020-02-03', '2020-05-03'),
(7, 15, '2020-08-03', '2020-11-03'),
(8,10, '2020-04-19', '2020-07-19')


insert into employees(employee_ssn, employee_firstname, employee_lastname, employee_email, employee_hiredate, employee_termdate, employee_jobtitle, employee_department, employee_payrate, employee_department_head, employee_hours_worked, employee_pay_date)
values 
(123345556, 'Abhijith', 'Vamadev', 'aavamadev@gmail.com', '2019-01-04', '', 'Manager', 'Administration', 20, 'Abhijith', 105,'2020-01-18'),
(233445567, 'Nyugen', 'Benezal', 'nygugen@gmail.com','2019-02-04', '', 'Manager', 'Catalouging', 20, 'Nyugen', 115, '2020-01-18'),
(234232131, 'Nickson', 'Davidson', 'nickson@gmail.com', '2020-04-05','', 'Student Employee', 'Administration', 12, 'Abhijith', 35, '2020-01-18'),
(459334213, 'Joe', 'Goldburg', 'joe@gmail.com', '2020-04-03', '', 'Student Employee', 'Administration', 12, 'Abhijith', 30, '2020-01-18'),
(293219321, 'Harley', 'Quinn', 'harley@gmail.com', '2020-03-04', '', 'Employee', 'Adminisration', 15, 'Abhijith', 55, '2020-01-18'),
(488233948, 'Melanie', 'Mellow','melanie@gmail.com', '2019-09-04', '2020-02-05', 'Employee', 'Catalouging', 15, 'Nyugen', 66, '2020-02-05'),
(872732739, 'Bob', 'Builder', 'bob@gmail.com', '2019-10-10', '', 'Employee', 'Catalouging', 15, 'Nyugen', 88, '2020-01-18'),
(090832983, 'Dim', 'Dwight', 'dim@gmail.com','2020-03-01', '', 'Student Employee', 'Catalouging', 12, 'Nyugen', 53, '2020-01-18'),
(928398123, 'Jackway', 'Mclovin', 'hackway@gmail.com','2020-01-03', '', 'Employee', 'Catalouging', 15, 'Nyugen', 44, '2020-01-18'),
(928392183, 'Tim', 'Jonathan', 'tim@gmail.com','2019-05-15', '', 'Employee', 'Catalouging', 15, 'Nyugen', 100, '2020-01-18'),
(623727382, 'Jacksay', 'Witman','jackshawy@gmail.com', '2019-05-15', '', 'Employee', 'Administration', 15, 'Abhijith', 99, '2020-01-18')
go

-- Verify
select * from books
select * from writers
select * from book_authors
select * from members
select * from reservations
select * from employees




--View Code
drop view if exists view_works_under
drop view if exists view_books_and_authors
drop view if exists students_cost
drop view if exists view_library_cost_students
drop view if exists view_reserved_books

go
 
create view view_reserved_books as
   select m.member_firstname + ' ' + m.member_lastname as 'Member Name',
       b.book_title as 'Book Title', b.book_category_name as 'Book Genre',
       r.reservation_date as 'Reservation Date', 
       r.reservation_return_date as 'Return Date for the book: '
       from reservations r
           join members m  on m.member_id = r.reservation_member_id
           join books b on b.book_id = r.reservation_book_id
       group by m.member_firstname, m.member_lastname, b.book_title, b.book_category_name, r.reservation_date, r.reservation_return_date
go

create view view_library_cost_students as
   select e.employee_firstname + ' ' + e.employee_lastname as 'Employee Name',
        e.employee_payrate as 'Employee Pay rate',
        e.employee_hours_worked as 'Total hours worked',  
        e.employee_payrate * e.employee_hours_worked as 'Total Gross Pay',
        e.employee_department_head as 'Reports to: '  
        from employees e
        where employee_jobtitle = 'Student Employee'
go 


create view students_cost as
   select SUM(e.employee_hours_worked * e.employee_payrate) as 'Total Cost of Hiring Students'
        from employees e
        where employee_jobtitle = 'Student Employee'
go 

go
create view view_books_and_authors as
   select b.book_title as 'Book Title', 
   b.book_category_name as 'Category', 
   w.writer_first_name + ' ' + w.writer_last_name as 'Writers Name'
       from books b
           join book_authors a  on a.book_author_book_id = b.book_id
           join writers w on w.writer_id = a.book_author_author_id
       group by b.book_title, b.book_category_name, w.writer_first_name, w.writer_last_name
go



create view view_works_under as 
    select e.employee_firstname + ' ' + e.employee_lastname as 'Employee Name', 
        e.employee_jobtitle as 'Employee Job Title', 
        e.employee_hours_worked as 'Employee Hours worked',
        e.employee_department_head as 'Department Head',
        COUNT(e.employee_id) as 'Total Employees'
        from employees e
        group by e.employee_firstname, e.employee_lastname, e.employee_jobtitle,e.employee_hours_worked, e.employee_department_head, e.employee_id
go 


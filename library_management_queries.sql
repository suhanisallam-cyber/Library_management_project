create database library_management;
use library_management;

-- drop table if exists authors;
-- Authors table
create table authors (
    author_id int primary key ,
    author_name varchar(100) not null,
    country varchar(50)
);
rename table authors to author_s;

-- Books table
create table  books_data (
    book_id int primary key ,
    title varchar (150) not null,
    author_id int,
    category varchar(50),
    publication_year int,
    total_copies int,
    available_copies int,
    foreign key  (author_id) references authors(author_id)
);
rename table book_s to books_data;

-- Members table
create table  members (
    member_id int primary key,
    member_name varchar(100) not null,
    email varchar (100),
    phone varchar(15),
    membership_date date
);

rename table members to member_s;

-- Borrowings table
create table borrowings (
    borrowing_id int primary key ,
    member_id int,
    book_id int,
    issue_date date,
    due_date date,
    return_date date,
    foreign key  (member_id) references members(member_id),
    foreign key  (book_id) references book_s(book_id)
);
rename table borrowings to borrowing_s;

-- Fine tabkle
create table fines (
    fine_id int primary key ,
    borrowing_id int ,
    fine_amount decimal(10,2),
    payment_status varchar (20),
    foreign key (borrowing_id) references borrowings (borrowing_id)
);

select*from authors;
select*from book_S;
select*from members;
select*from borrowings;
select*from fines;

-- Q1. Display all books.
  select *from books;
  
-- Q2. Display all library members.
  select *from members;
  
-- Q3. Find all books belonging to the "Science" category.
  select *from books
  where category = 'Science';

-- Q4. Find all books published after 2020.
   select*from books 
   where publication_year > 2020;

-- Q5. Find members who joined after 2024.
   select *from members
   where membership_date > '2024-12-31';
-- Q6. Display each book along with its author's name.
   select b.title,a.author_name
   from books b
   join  authors a ON b.author_id = a.author_id;
   
-- Q7. Display the name of each member and the books they borrowed.
   select  m.member_name,b.title
   from borrowings br
   join members m 
   on br.member_id = m.member_id
   join books b 
   on br.book_id = b.book_id;
   
-- Q8. Display complete borrowing details including member name, book title, issue date, and due date.
     select m.member_name, b.title, br.issue_date,
     br.due_date, br.return_date
	 from borrowings br
	 join members m
     on  br.member_id = m.member_id
     join  books b
	 on br.book_id = b.book_id;
     
     
-- Q9. Find all books written by a particular author.
    select  b.title, a.author_name
	from books b
	join authors a
     on  b.author_id = a.author_id
	where  a.author_name = 'J.K. Rowling';


-- Q10. Count the total number of books in the library.
     select  count(*) as total_books
     from books;
     
     
-- Q11. Count the total number of library members.
     select count(*) as total_members
	 from members;
     
-- Q12. Find the number of books in each category.
     select category,
	  count(*) as total_books
	 from books
	 group by category;
      
-- Q13. Find the most borrowed book.
    select  b.title,
    COUNT(br.borrowing_id) as times_borrowed
    from borrowings br
    join  books b
     on  br.book_id = b.book_id
    group by b.book_id, b.title
    order by times_borrowed desc
    limit 1;
    
    
-- Q14. Find the member who borrowed the most books.
   select m.member_name,
      COUNT(br.borrowing_id) as books_borrowed
   from borrowings br
   join members m
	 on br.member_id = m.member_id
    group by m.member_id, m.member_name
	order by books_borrowed desc
     limit 1;
-- Q15. Find all currently borrowed books.
    select  m.member_name, b.title,
    br.issue_date, br.due_date
	from borrowings br
	join members m
      on br.member_id = m.member_id
     join books b
       on  br.book_id = b.book_id
	 where br.return_date IS NULL;
     
-- Q16. Find all overdue books.
   select  m.member_name, b.title, br.due_date
   from  borrowings br
   join  members m
   on br.member_id = m.member_id
   join books b
    on br.book_id = b.book_id
   where br.return_date is null 
   and br.due_date < CURDATE();
  
-- Q17. Calculate the fine for overdue books.
    select m.member_name, b.title, br.due_date,
     DATEDIFF(CURDATE(), br.due_date) as overdue_days,
     DATEDIFF(CURDATE(), br.due_date) * 5 as fine_amount
    from borrowings br
	join members m
	 on br.member_id = m.member_id
	join  books b
	 on br.book_id = b.book_id
    where br.return_date is null
    AND br.due_date < curdate();
    
    
-- Q18. Find members who have never borrowed a book.
   select m.member_id, m.member_name
   from members m
   left join borrowings br
    on  m.member_id = br.member_id
   where  br.borrowing_id is null;
   
   
-- Q19. Find authors who have more than one book.
   select a.author_name,
    count(b.book_id) as total_books
   from authors a
   join books b
    on a.author_id = b.author_id
   group by a.author_id, a.author_name
   having count(b.book_id) > 1;
   
   
-- Q20. Find the most active library member.
   select m.member_name,
    count(br.borrowing_id) as total_borrowings
   from members m
   join borrowings br
    on m.member_id = br.member_id
   group by  m.member_id, m.member_name
   order by total_borrowings desc
   limit 1;

select books.title, books.author, categories.category_name 
from books 
join categories on books.category_id = categories.category_id 
order by books.title;

select readers.full_name, count(borrowing.book_id) as total_borrowed 
from borrowing 
join readers on borrowing.reader_id = readers.reader_id 
group by readers.full_name;

select avg(fines.fine_amount) as average_fine from fines;

select books.title, books.quantity 
from books 
where books.quantity = (select max(quantity) from books);

select readers.full_name, fines.fine_amount 
from fines 
join returning on fines.return_id = returning.return_id 
join borrowing on returning.borrow_id = borrowing.borrow_id 
join readers on borrowing.reader_id = readers.reader_id 
where fines.fine_amount > 0;

select books.title, count(borrowing.book_id) as borrow_count 
from borrowing 
join books on borrowing.book_id = books.book_id 
group by books.title 
having borrow_count = (select max(borrow_count) 
                       from (select count(book_id) as borrow_count 
                             from borrowing 
                             group by book_id) as max_borrow);

select books.title, readers.full_name, borrowing.borrow_date 
from borrowing 
join books on borrowing.book_id = books.book_id 
join readers on borrowing.reader_id = readers.reader_id 
left join returning on borrowing.borrow_id = returning.borrow_id 
where returning.return_id is null 
order by borrowing.borrow_date;

select readers.full_name, books.title 
from borrowing 
join books on borrowing.book_id = books.book_id 
join readers on borrowing.reader_id = readers.reader_id 
join returning on borrowing.borrow_id = returning.borrow_id 
where returning.return_date <= borrowing.return_date;

select books.title, books.publication_year 
from books 
where books.book_id = (select book_id from borrowing 
                       group by book_id 
                       order by count(book_id) desc 
                       limit 1);

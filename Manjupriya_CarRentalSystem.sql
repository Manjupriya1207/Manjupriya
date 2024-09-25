-- Coding Challenge - Car Rental System – SQL
create database cardb;
use cardb;
create table Vehicle (
    vehicleID int primary key,
    make varchar(50),
    model varchar(50),
    year int,
    dailyRate decimal(10, 2),
    status tinyint, 
    passengerCapacity int,
    engineCapacity decimal(7, 2)
);
insert into Vehicle (vehicleID, make, model, year, dailyRate, status, passengerCapacity, engineCapacity)
values
(1, 'Toyota', 'Camry', 2022, 50.00, 1, 4, 1450),
(2, 'Honda', 'Civic', 2023, 45.00, 1, 7, 1500),
(3, 'Ford', 'Focus', 2022, 48.00, 0, 4, 1400),
(4, 'Nissan', 'Altima', 2023, 52.00, 1, 7, 1200),
(5, 'Chevrolet', 'Malibu', 2022, 47.00, 1, 4, 1800),
(6, 'Hyundai', 'Sonata', 2023, 49.00, 0, 7, 1400),
(7, 'BMW', '3 Series', 2023, 60.00, 1, 7, 2499),
(8, 'Mercedes', 'C-Class', 2022, 58.00, 1, 8, 2599),
(9, 'Audi', 'A4', 2022, 55.00, 0, 4, 2500),
(10, 'Lexus', 'ES', 2023, 54.00, 1, 4, 2500);
create table Customer(
customerID int Primary Key,
firstName varchar(50),
lastName varchar(50),
email varchar(100),
phoneNumber varchar(15)
);
insert into Customer (customerID, firstName, lastName, email, phoneNumber)
values
(1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555'),
(2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
(3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
(5, 'David', 'Lee', 'david@example.com', '555-987-6543'),
(6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678'),
(7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432'),
(8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
(9, 'William', 'Taylor', 'william@example.com', '555-321-6547'),
(10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321');
create table Lease(
leaseID int Primary Key,
vehicleID int,
customerID int,
startDate date,
endDate date,
type enum( 'DailyLease' , 'MonthlyLease'),
Foreign Key(vehicleID) references Vehicle (vehicleID),
Foreign Key (customerID) references Customer (customerID)
);
alter table Lease modify type enum('Daily', 'Monthly');
insert into Lease (leaseID, vehicleID, customerID, startDate, endDate, type)
values
(1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
(3, 3, 3, '2023-03-10', '2023-03-15', 'Daily'),
(4, 4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
(5, 5, 5, '2023-05-05', '2023-05-10', 'Daily'),
(6, 4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
(7, 7, 7, '2023-07-01', '2023-07-10', 'Daily'),
(8, 8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
(9, 3, 3, '2023-09-07', '2023-09-10', 'Daily'),
(10, 10, 10, '2023-10-10', '2023-10-31', 'Monthly');
create table Payment(
paymentID int Primary Key,
leaseID int,
paymentDate date,
amount decimal(10,2),
Foreign Key (leaseID) references Lease (leaseID)
);
insert into Payment (paymentID, leaseID, paymentDate, amount)
values
(1, 1, '2023-01-03', 200.00),
(2, 2, '2023-02-20', 1000.00),
(3, 3, '2023-03-12', 75.00),
(4, 4, '2023-04-25', 900.00),
(5, 5, '2023-05-07', 60.00),
(6, 6, '2023-06-18', 1200.00),
(7, 7, '2023-07-03', 40.00),
(8, 8, '2023-08-14', 1100.00),
(9, 9, '2023-09-09', 80.00),
(10, 10, '2023-10-25', 1500.00);
-- 1. Update the daily rate for a Mercedes car to 68.
update Vehicle 
set dailyRate = 68 
where make = 'Mercedes';
-- 2. Delete a specific customer and all associated leases and payments.
delete from Payment 
where leaseID in (select leaseID from Lease where customerID = 1);
delete from Lease 
where customerID = 1;
delete from Customer 
where customerID = 1;
-- 3. Rename the "paymentDate" column in the Payment table to "transactionDate".
alter table Payment 
change paymentDate transactionDate date;
select * from payment;
-- 4. Find a specific customer by email.
select * from Customer where email = 'janesmith@example.com';
-- 5. Get active leases for a specific customer.
select leaseID, startDate, endDate, CURDATE() AS currentDate 
from Lease 
where customerID = 2;
-- 6. Find all payments made by a customer with a specific phone number.
select P.* ,C.firstName
from Payment P
join Lease L on P.leaseID = L.leaseID
join Customer C on L.customerID = C.customerID
where C.phoneNumber = '555-789-1234';
-- 7. Calculate the average daily rate of all available cars.
select avg(dailyRate) as AverageDailyRate 
from Vehicle 
where status = 1; 
-- 8. Find the car with the highest daily rate.
select * 
from Vehicle 
order by dailyRate desc ;
-- 9. Retrieve all cars leased by a specific customer.
select V.* 
from Vehicle V
join Lease L on V.vehicleID = L.vehicleID
where L.customerID = 4;
-- 10. Find the details of the most recent lease.
select * 
from Lease 
order by startDate desc;
-- 11. List all payments made in the year 2023.
select * 
from Payment 
where year(transactionDate) = 2023;
-- 12. Retrieve customers who have not made any payments.
select C.* 
from Customer C
left join Lease L on C.customerID = L.customerID
left join Payment P on L.leaseID = P.leaseID
where P.paymentID is null;
-- 13. Retrieve Car Details and Their Total Payments.
select V.*, SUM(P.amount) as TotalPayments 
from Vehicle V
join Lease L on V.vehicleID = L.vehicleID
join Payment P on L.leaseID = P.leaseID
group by V.vehicleID;
-- 14. Calculate Total Payments for Each Customer
select C.customerID, C.firstName, C.lastName, SUM(P.amount) AS TotalPayments 
from Customer C
join  Lease L on C.customerID = L.customerID
join  Payment P on L.leaseID = P.leaseID
group by C.customerID;
-- 15. List Car Details for Each Lease.
select L.leaseID ,V.*
from Vehicle V
join  Lease L on V.vehicleID = L.vehicleID;
-- 16. Retrieve Details of Active Leases with Customer and Car Information.
select L.leaseID, C.*, V.* from Lease L
join Customer C on L.customerID = C.customerID
join Vehicle V on L.vehicleID = V.vehicleID
where L.endDate >= now();
-- 17. Find the Customer Who Has Spent the Most on Leases.
select C.customerID, C.firstName, C.lastName, SUM(P.amount) as TotalSpent
from Customer C
join Lease L ON C.customerID = L.customerID
join Payment P ON L.leaseID = P.leaseID
group by C.customerID
having TotalSpent = (
select MAX(totalSpent)
from (select SUM(P.amount) as totalSpent
from Customer C
join Lease L ON C.customerID = L.customerID
join Payment P ON L.leaseID = P.leaseID
group by C.customerID
) as Max_spend
);
-- 18. List All Cars with Their Current Lease Information.
select V.*, L.* 
from Vehicle V
left join Lease L on V.vehicleID = L.vehicleID 
where L.endDate > CURDATE();





--*************************************************************************--
-- Title: Assignment06
-- Author: JojiTanase
-- Desc: This file demonstrates how to use Views
-- Change Log:
-- 8/16/2022, Joji Tanase, Created File + Question 1
-- 8/18/2022, Joji Tanase, Question 2-4
-- 8/19/2022,Joji Tanase, Question 5-10
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_JojiTanase')
	 Begin 
	  Alter Database [Assignment06DB_JojiTanase] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_JojiTanase;
	 End
	Create Database Assignment06DB_JojiTanase;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_JojiTanase;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [mOney] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, UnitsInStock
From Northwind.dbo.Products
UNIOn
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, UnitsInStock + 10 -- Using this is to create a made up value
From Northwind.dbo.Products
UNIOn
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, UnitsInStock + 20 -- Using this is to create a made up value
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

/********************************* Questions and Answers *********************************/
print 
'NOTES------------------------------------------------------------------------------------ 
 1) You can use any name you like for you views, but be descriptive and consistent
 2) You can use your working code from assignment 5 for much of this assignment
 3) You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'

-- Question 1 (5% pts): How can you create BACIC views to show data from each table in the database.
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!

/*
--1. Create Views
Create View vCategories
	As
		Select CategoryID, CategoryName
		From dbo.Categories;
go
Create View vProducts
	As
		Select ProductID, ProductName, CategoryID, UnitPrice
		From dbo.Products;
go
Create View vEmployees	
	As
		Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID
		From dbo.Employees;
go
Create View vInventories
	As
		Select InventoryID, InventoryDate, EmployeeID, ProductID, [Count]
		From dbo.Inventories;
go
*/

--2. Use SchemaBinding to protect the views
go
Create View vCategories
	With Schemabinding
	As
		Select CategoryID, CategoryName
		From dbo.Categories;
go
Create View vProducts
	With Schemabinding
	As
		Select ProductID, ProductName, CategoryID, UnitPrice
		From dbo.Products;
go
Create View vEmployees	
	With Schemabinding
	As
		Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID
		From dbo.Employees;
go
Create View vInventories
	With Schemabinding
	As
		Select InventoryID, InventoryDate, EmployeeID, ProductID, [Count]
		From dbo.Inventories;
go
-- Question 2 (5% pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view?

/*
--1. Public group cannot select data from table
Deny Select Categories to Public;
Deny Select Products to Public;
Deny Select Employees to Public;
Deny Select Inventories to Public;
*/

--2. Public can select from Views and not tables
Deny Select On Categories to Public;
Deny Select On Products to Public;
Deny Select On Employees to Public;
Deny Select On Inventories to Public;
Grant Select On vCategories to Public;
Grant Select On vProducts to Public;
Grant Select On vEmployees to Public;
Grant Select On vInventories to Public;
go

-- Question 3 (10% pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product!

/*
--1. Create View with CategoryName from vCategories and ProductName from vProducts
Create View vProductsByCategories
	With SchemaBinding
	As
		Select 
			C.CategoryName
			,P.ProductName
			,P.UnitPrice
		From dbo.vCategories as C
		Inner Join dbo.vProducts as P
			On C.CategoryID = P.CategoryID;
go
*/

--2. Order by CategoryName and ProductName
Create View vProductsByCategories
	With Schemabinding
	As
		Select Top 100000
			C.CategoryName
			,P.ProductName
			,P.UnitPrice
		From dbo.vCategories as C
		Inner Join dbo.vProducts as P
			On C.CategoryID = P.CategoryID
	Order By C.CategoryName, P.ProductName
go

-- Question 4 (10% pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!

/*
--1. Create view with ProductName, InventoryDate, Count
Create View vInventoriesByProductsByDates
	With Schemabinding
	As
		Select
			P.ProductName
			,I.InventoryDate
			,I.[Count]
		From dbo.vProducts as P
		Inner Join dbo.vInventories as I
			On P.ProductID = I.ProductID;
go
*/

--2. Order by ProductName, InventoryDate, and Count
Create View vInventoriesByProductsByDates
	With Schemabinding
	As
		Select Top 100000
			P.ProductName
			,I.InventoryDate
			,I.[Count]
		From dbo.vProducts as P
		Inner Join dbo.vInventories as I
			On P.ProductID = I.ProductID
		Order By ProductName, InventoryDate, [Count];
go


-- Question 5 (10% pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!

/*
--1. Create View with InvetoryDate, EmployeeName
Create View vInventoriesByEmployeesByDates
	With Schemabinding
	As
		Select
			I.InventoryDate
			,E.EmployeeFirstName + ' ' + E.EmployeeLastName as EmployeeName
		From dbo.vInventories as I
		Inner Join dbo.vEmployees as E
			On I.EmployeeID = E.EmployeeID;
go		

--2. Order By InvetoryDate
Create View vInventoriesByEmployeesByDates
	With Schemabinding
	As
		Select Top 100000
			I.InventoryDate
			,E.EmployeeFirstName + ' ' + E.EmployeeLastName as EmployeeName
		From dbo.vInventories as I
		Inner Join dbo.vEmployees as E
			On I.EmployeeID = E.EmployeeID
		Order By InventoryDate;
go		
*/

--3. Return only one row per date
Create View vInventoriesByEmployeesByDates
	With Schemabinding
	As
		Select Distinct Top 100000
			I.InventoryDate
			,E.EmployeeFirstName + ' ' + E.EmployeeLastName as EmployeeName
		From dbo.vInventories as I
		Inner Join dbo.vEmployees as E
			On I.EmployeeID = E.EmployeeID
		Order By InventoryDate;
go		

-- Question 6 (10% pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!

/*
--1. Create View with CategoryName, ProductName, InventoryDate, Count
Create View vInventoriesByProductsByCategories
	With Schemabinding
	As
		Select
			C.CategoryName
			,P.ProductName
			,I.InventoryDate
			,I.[Count]
		From dbo.vCategories as C
		Inner Join dbo.vProducts as P
			On C.CategoryID = P.CategoryID
		Inner Join dbo.vInventories as I
			On P.ProductID = I.ProductID;
go
*/

--2. Order By CategoryName, ProductName, InventoryDate, Count
Create View vInventoriesByProductsByCategories
	With Schemabinding
	As
		Select Top 100000
			C.CategoryName
			,P.ProductName
			,I.InventoryDate
			,I.[Count]
		From dbo.vCategories as C
		Inner Join dbo.vProducts as P
			On C.CategoryID = P.CategoryID
		Inner Join dbo.vInventories as I
			On P.ProductID = I.ProductID
		Order By CategoryName, ProductName, InventoryDate, [Count];
go

-- Question 7 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!

/*
--1. Create View with CategoryName, ProductName, InventoryDate, Count, EmployeeName
Create View vInventoriesByProductsByEmployees
	With Schemabinding
	As
		Select
			C.CategoryName
			,P.ProductName
			,I.InventoryDate
			,I.[Count]
			,E.EmployeeFirstName + ' ' + E.EmployeeLastName as EmployeeName
		From dbo.vCategories as C
		Join dbo.vProducts as P
			On C.CategoryID = P.CategoryID
		Join dbo.vInventories as I
			On P.ProductID = I.ProductID
		Join dbo.vEmployees as E
			On I.EmployeeID = E.EmployeeID;
go
*/

--2. Order by InventoryDate, CategoryName, ProductName, EmployeeName
Create View vInventoriesByProductsByEmployees
	With Schemabinding
	As
		Select Top 100000
			C.CategoryName
			,P.ProductName
			,I.InventoryDate
			,I.[Count]
			,E.EmployeeFirstName + ' ' + E.EmployeeLastName as EmployeeName
		From dbo.vCategories as C
		Join dbo.vProducts as P
			On C.CategoryID = P.CategoryID
		Join dbo.vInventories as I
			On P.ProductID = I.ProductID
		Join dbo.vEmployees as E
			On I.EmployeeID = E.EmployeeID
		Order by InventoryDate, CategoryName, ProductName, EmployeeName;
go


-- Question 8 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? 

--1. Use q7 step 1 and filter by Chai and Chang
Create View vInventoriesForChaiAndChangByEmployees
	With Schemabinding
	As
		Select Top 100000
			C.CategoryName
			,P.ProductName
			,I.InventoryDate
			,I.[Count]
			,E.EmployeeFirstName + ' ' + E.EmployeeLastName as EmployeeName
		From dbo.vCategories as C
		Join dbo.vProducts as P
			On C.CategoryID = P.CategoryID
		Join dbo.vInventories as I
			On P.ProductID = I.ProductID
		Join dbo.vEmployees as E
			On I.EmployeeID = E.EmployeeID
		Where P.ProductName In ('Chai', 'Chang')
go

-- Question 9 (10% pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!

/*
--1. Create View with Manager and Employee through Selfjoin
Create View vEmployeesByManager
	With Schemabinding
	As
		Select
			M.EmployeeFirstName + ' ' + M.EmployeeLastName as Manager
			,E.EmployeeFirstName + ' ' + E.EmployeeLastName as Employee
		From dbo.vEmployees as M
		Inner Join dbo.vEmployees as E
			On M.ManagerID = E.EmployeeID;
go
*/

--2. Order by Manager and Employee
Create View vEmployeesByManager
	With Schemabinding
	As
		Select Top 100000
			M.EmployeeFirstName + ' ' + M.EmployeeLastName as Manager
			,E.EmployeeFirstName + ' ' + E.EmployeeLastName as Employee
		From dbo.vEmployees as E
		Inner Join dbo.vEmployees as M
			On E.ManagerID = M.EmployeeID
		Order By Manager, Employee
go

-- Question 10 (20% pts): How can you create one view to show all the data from all four 
-- BASIC Views? Also show the Employee's Manager Name and order the data by 
-- Category, Product, InventoryID, and Employee.

/*
--1. Create View from Categories, Products, Inventory
Create View vInventoriesByProductsByCategoriesByEmployees
	With Schemabinding
	As
		Select
			C.CategoryID
			,C.CategoryName
			,P.ProductID
			,P.ProductName
			,P.UnitPrice
			,I.InventoryID
			,I.InventoryDate
			,I.[Count]
		From dbo.vCategories as C
		Inner Join dbo.vProducts as P
			On C.CategoryID = P.CategoryID
		Inner Join dbo.vInventories as I
			On P.ProductID = I.ProductID;
go

--2. Add Employee and Manager from q9
Create View vInventoriesByProductsByCategoriesByEmployees
	With Schemabinding
	As
		Select
			C.CategoryID
			,C.CategoryName
			,P.ProductID
			,P.ProductName
			,P.UnitPrice
			,I.InventoryID
			,I.InventoryDate
			,I.[Count]
			,E.EmployeeID
			,E.EmployeeFirstName + ' ' + E.EmployeeLastName as Employee
			,M.EmployeeFirstName + ' ' + M.EmployeeLastName as Manager
		From dbo.vCategories as C
		Inner Join dbo.vProducts as P
			On C.CategoryID = P.CategoryID
		Inner Join dbo.vInventories as I
			On P.ProductID = I.ProductID
		Inner Join dbo.vEmployees as E
			On I.EmployeeID = E.EmployeeID
		Inner Join dbo.vEmployees as M
			On E.ManagerID = M.EmployeeID;
go
*/

--3. Order by CategoryName, ProductName, InventoryID, and Employee.
Create View vInventoriesByProductsByCategoriesByEmployees
	With Schemabinding
	As
		Select Top 100000
			C.CategoryID
			,C.CategoryName
			,P.ProductID
			,P.ProductName
			,P.UnitPrice
			,I.InventoryID
			,I.InventoryDate
			,I.[Count]
			,E.EmployeeID
			,E.EmployeeFirstName + ' ' + E.EmployeeLastName as Employee
			,M.EmployeeFirstName + ' ' + M.EmployeeLastName as Manager
		From dbo.vCategories as C
		Inner Join dbo.vProducts as P
			On C.CategoryID = P.CategoryID
		Inner Join dbo.vInventories as I
			On P.ProductID = I.ProductID
		Inner Join dbo.vEmployees as E
			On I.EmployeeID = E.EmployeeID
		Inner Join dbo.vEmployees as M
			On E.ManagerID = M.EmployeeID
		Order By CategoryName, ProductName, InventoryID, Employee;
go

-- Test your Views (NOTE: You must change the names to match yours as needed!)
Print 'Note: You will get an error until the views are created!'
Select * From [dbo].[vCategories]
Select * From [dbo].[vProducts]
Select * From [dbo].[vInventories]
Select * From [dbo].[vEmployees]

Select * From [dbo].[vProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByDates]
Select * From [dbo].[vInventoriesByEmployeesByDates]
Select * From [dbo].[vInventoriesByProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByEmployees]
Select * From [dbo].[vInventoriesForChaiAndChangByEmployees]
Select * From [dbo].[vEmployeesByManager]
Select * From [dbo].[vInventoriesByProductsByCategoriesByEmployees]

/***************************************************************************************/
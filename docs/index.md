Joji Tanase <br>
8/24/2022 <br>
IT FDN 130 <br>
Assignment 7 <br>
[https://github.com/CodeLangLearn/DBFoundations](https://github.com/CodeLangLearn/DBFoundations_Module07)<br>

<h1 align="center">Module 07  - SQL UDF. Scalar, Inline, and Multi-Statement Functions</h1>

## Introduction
I will first explain SQL User Defined Functions (UDF) and when it would be used. Next, I will go over the differences between Scalar, Inline, and Multi-Statement Functions.

## SQL UDF
SQL User Defined Functions (UDF) is a way for a user to create their own function. There are 3 types of UDFs, Scalar for simple equations, inline table-valued which uses a select statement for a variable, and multi-statement function which has the most complex code and returns a table. These functions are useful if you have to use a function many times because it will save the function and you do not have to rewrite or copy the code. UDFs are useful for checking constraints such as determining KPI from a table or view. Another useful time to use SQL UDF is to do an Extraction, Transformation, and Loading (ETL) process. This process allows to extract information from a column when there may be a lack of consistency, transform it, then load it in a new way. A great use case is to separate the full name into first and last and the 10-digit phone number into area code and phone number (Functions-04 Using Functions for ETL Processing, YouTube, 8/8/2017, [https://youtu.be/URSjRbN1rCQ](https://youtu.be/URSjRbN1rCQ), 8/24/2022 [External Site]).

Differences: Scalar, Inline, and Multi-Statement Functions
There are 3 different types of UDFs. Scalar UDFs are used return a single value such as data types int, varchar, or date. Scalar functions are useful to put variables through various mathematical formulas to provide with a single value.
Inline UDFs are used to return a single set of rows using a single Select statement (Inline and multi-statement table-valued functions, A. Brown, 2/8/2013, [https://www.wiseowl.co.uk/blog/s347/in-line.htm](https://www.wiseowl.co.uk/blog/s347/in-line.htm), 8/24/2022 [External Site]). Inline UDFs are different from Scalar UDFs because the function allows for users to use the select function to show results as a table instead of a single value. This can useful to filter the data by a specific parameter you set using the function. The Inline UDF will not work with Begin and End unlike Scalar functions.
Multi-Statement Table-Valued Function (MSTVF) is a UDF that returns table a table of data (Multi-Statement Table-Valued Functions, A. Brown, 2/8/2013, [https://www.wiseowl.co.uk/blog/s347/in-line.htm](https://www.wiseowl.co.uk/blog/s347/in-line.htm), 8/24/2022 [External Site]). MSTVF is a multi-statement functions that can use if -then-else statements to return a whole table. This is different from a Scalar or Inline UDF because they return a single value and rows of data from a single select, respectively. 

## Summary
SQL UDF is a great tool for users for constraints, reducing repetition of code, and ETL. The three different types of UDF, Scalar, Inline, and Multi-Statement Table-Valued Functions are all very similar, but are different primarily because of what is used to define the result and the data that is returned from the function.

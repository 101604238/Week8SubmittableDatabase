﻿CREATE TABLE [dbo].[Student]
(
	[StudentID] NVARCHAR(9) NOT NULL PRIMARY KEY,
	[FirstName] NVARCHAR(30) NOT NULL,
	[LastName] NVARCHAR(30) NOT NULL,
	[Email] NVARCHAR(100) NOT NULL,
	[MobilePhone] NVARCHAR(10)
	
)

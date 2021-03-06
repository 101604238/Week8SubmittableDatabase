﻿CREATE TABLE [dbo].[Book]
(
	[ISBN] NVARCHAR(17) NOT NULL,
	[Title] NVARCHAR(100) NOT NULL,
	[Year] INT NOT NULL,
	[AuthorID] NVARCHAR(5) NOT NULL,

	CONSTRAINT Pk_Book PRIMARY KEY (ISBN),
	CONSTRAINT Fk_Book FOREIGN KEY (AuthorID) REFERENCES Author
)

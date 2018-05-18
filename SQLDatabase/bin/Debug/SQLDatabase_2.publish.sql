﻿/*
Deployment script for Week9SubmittableDatabase

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar LoadTestData "true"
:setvar DatabaseName "Week9SubmittableDatabase"
:setvar DefaultFilePrefix "Week9SubmittableDatabase"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
/*
The type for column AuthorID in table [dbo].[Author] is currently  NVARCHAR (30) NOT NULL but is being changed to  NVARCHAR (5) NOT NULL. Data loss could occur.
*/

IF EXISTS (select top 1 1 from [dbo].[Author])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
/*
The column [dbo].[Book].[Published] is being dropped, data loss could occur.

The type for column AuthorID in table [dbo].[Book] is currently  NVARCHAR (30) NOT NULL but is being changed to  NVARCHAR (5) NOT NULL. Data loss could occur.

The type for column ISBN in table [dbo].[Book] is currently  NVARCHAR (20) NOT NULL but is being changed to  NVARCHAR (17) NOT NULL. Data loss could occur.
*/

IF EXISTS (select top 1 1 from [dbo].[Book])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
/*
The type for column StudentID in table [dbo].[Student] is currently  NVARCHAR (20) NOT NULL but is being changed to  NVARCHAR (9) NOT NULL. Data loss could occur.
*/

IF EXISTS (select top 1 1 from [dbo].[Student])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Dropping [dbo].[Fk_Book]...';


GO
ALTER TABLE [dbo].[Book] DROP CONSTRAINT [Fk_Book];


GO
PRINT N'Starting rebuilding table [dbo].[Author]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Author] (
    [AuthorID]      NVARCHAR (5)  NOT NULL,
    [FirstName]     NVARCHAR (30) NOT NULL,
    [LastName]      NVARCHAR (30) NOT NULL,
    [taxFileNumber] INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([AuthorID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Author])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Author] ([AuthorID], [FirstName], [LastName], [taxFileNumber])
        SELECT   [AuthorID],
                 [FirstName],
                 [LastName],
                 [taxFileNumber]
        FROM     [dbo].[Author]
        ORDER BY [AuthorID] ASC;
    END

DROP TABLE [dbo].[Author];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Author]', N'Author';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Starting rebuilding table [dbo].[Book]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Book] (
    [ISBN]     NVARCHAR (17)  NOT NULL,
    [Title]    NVARCHAR (100) NOT NULL,
    [Year]     INT            NOT NULL,
    [AuthorID] NVARCHAR (5)   NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_Pk_Book1] PRIMARY KEY CLUSTERED ([ISBN] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Book])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Book] ([ISBN], [Title], [Year], [AuthorID])
        SELECT   [ISBN],
                 [Title],
                 [Year],
                 [AuthorID]
        FROM     [dbo].[Book]
        ORDER BY [ISBN] ASC;
    END

DROP TABLE [dbo].[Book];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Book]', N'Book';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_Pk_Book1]', N'Pk_Book', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Starting rebuilding table [dbo].[Student]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Student] (
    [StudentID]   NVARCHAR (9)   NOT NULL,
    [FirstName]   NVARCHAR (30)  NOT NULL,
    [LastName]    NVARCHAR (30)  NOT NULL,
    [Email]       NVARCHAR (100) NOT NULL,
    [MobilePhone] NVARCHAR (10)  NULL,
    PRIMARY KEY CLUSTERED ([StudentID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Student])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Student] ([StudentID], [FirstName], [LastName], [Email], [MobilePhone])
        SELECT   [StudentID],
                 [FirstName],
                 [LastName],
                 [Email],
                 [MobilePhone]
        FROM     [dbo].[Student]
        ORDER BY [StudentID] ASC;
    END

DROP TABLE [dbo].[Student];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Student]', N'Student';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[Fk_Book]...';


GO
ALTER TABLE [dbo].[Book] WITH NOCHECK
    ADD CONSTRAINT [Fk_Book] FOREIGN KEY ([AuthorID]) REFERENCES [dbo].[Author] ([AuthorID]);


GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

IF '$(LoadTestData)' = 'true'

BEGIN

	DELETE FROM BOOK;
	DELETE FROM STUDENT;
	DELETE FROM AUTHOR;
	
	INSERT INTO AUTHOR(AuthorID, FirstName, LastName, taxFileNumber) VALUES
	('32567', 'Edgar', 'Codd', 150111222),
	('76543', 'Vinton', 'Cerf', 150222333),
	('12345', 'Alan', 'Turing', 150333444);

	INSERT INTO STUDENT(StudentID, FirstName, LastName, Email, MobilePhone) VALUES
	('s12345678', 'Fred', 'Flintstone',  '12345678@student.swin.edu.au', '0400555111'),
	('s23456789', 'Barney', 'Rubble',  '23456789@student.swin.edu.au', '0400555222'),
	('s34567890', 'Bam-Bam', 'Rubble',  '34567890@student.swin.edu.au', '0400555333');

	INSERT INTO BOOK(ISBN, Title, [Year], AuthorID) VALUES
	('978-3-16-148410-0', 'Relationships with Databases, the ins and outs', 1970, '32567'),
	('978-3-16-148410-1', 'Normalisation, how to make a database geek fit in.', 1973, '32567'),
	('978-3-16-148410-2', 'TCP/IP, the protocol for the masses.', 1983, '76543'),
	('978-3-16-148410-3', 'The Man, the Bombe, and the Enigma.', 1940, '12345');

END;
GO

GO

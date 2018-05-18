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
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
PRINT N'Creating [dbo].[Author]...';


GO
CREATE TABLE [dbo].[Author] (
    [AuthorID]      NVARCHAR (30) NOT NULL,
    [FirstName]     NVARCHAR (20) NOT NULL,
    [LastName]      NVARCHAR (20) NOT NULL,
    [taxFileNumber] INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([AuthorID] ASC)
);


GO
PRINT N'Creating [dbo].[Book]...';


GO
CREATE TABLE [dbo].[Book] (
    [ISBN]      NVARCHAR (20)  NOT NULL,
    [Title]     NVARCHAR (100) NOT NULL,
    [Year]      INT            NOT NULL,
    [Published] INT            NOT NULL,
    [AuthorID]  NVARCHAR (30)  NOT NULL,
    CONSTRAINT [Pk_Book] PRIMARY KEY CLUSTERED ([ISBN] ASC)
);


GO
PRINT N'Creating [dbo].[Student]...';


GO
CREATE TABLE [dbo].[Student] (
    [StudentID]   NVARCHAR (20)  NOT NULL,
    [FirstName]   NVARCHAR (20)  NOT NULL,
    [LastName]    NVARCHAR (20)  NOT NULL,
    [Email]       NVARCHAR (100) NOT NULL,
    [MobilePhone] NVARCHAR (10)  NULL,
    PRIMARY KEY CLUSTERED ([StudentID] ASC)
);


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
	(32567, 'Edgar', 'Codd', '150 111 222'),
	(76543, 'Vinton', 'Cerf', '150 222 333'),
	(12345, 'Alan', 'Turing', '150 333 444');

	INSERT INTO STUDENT(StudentID, FirstName, LastName, Email, MobilePhone) VALUES
	('s12345678', 'Fred', 'Flintstone',  '12345678@student.swin.edu.au', '0400 555 111'),
	('s23456789', 'Barney', 'Rubble',  '23456789@student.swin.edu.au', '0400 555 222'),
	('s34567890', 'Bam-Bam', 'Rubble',  '34567890@student.swin.edu.au', '0400 555 333');

	INSERT INTO BOOK(ISBN, Title, Year, AuthorID) VALUES
	('978-3-16-148410-0', 'Relationships with Databases, the ins and outs', 1970, 32567),
	('978-3-16-148410-1', 'Normalisation, how to make a database geek fit in.', 1973, 32567),
	('978-3-16-148410-2", "TCP/IP, the protocol for the masses.', 1983, 76543),
	('978-3-16-148410-3', 'The Man, the Bombe, and the Enigma.', 1940, 12345);

END;


GO

GO

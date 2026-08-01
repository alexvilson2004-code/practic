IF DB_ID(N'CompanyRequests') IS NULL
    CREATE DATABASE CompanyRequests;
GO

USE CompanyRequests;
GO

IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = 'webuser')
BEGIN
    CREATE LOGIN webuser
    WITH PASSWORD = 'StrongPass123!',
         CHECK_POLICY = ON,
         CHECK_EXPIRATION = OFF;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'RequestStatus')
BEGIN
    CREATE TABLE dbo.RequestStatus
    (
        StatusId   INT          NOT NULL PRIMARY KEY,
        StatusName NVARCHAR(50) NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Requests')
BEGIN
    CREATE TABLE dbo.Requests
    (
        Id            INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        RequestDate   DATETIME2 NOT NULL CONSTRAINT DF_Requests_RequestDate DEFAULT SYSDATETIME(),
        EmployeeName  NVARCHAR(100) NOT NULL,
        Department    NVARCHAR(100) NOT NULL,
        Title         NVARCHAR(200) NOT NULL,
        Description   NVARCHAR(MAX) NOT NULL,
        Priority      TINYINT NOT NULL CONSTRAINT DF_Requests_Priority DEFAULT(2),
        StatusId      INT NOT NULL CONSTRAINT DF_Requests_Status DEFAULT(1),
        ClosedDate    DATETIME2 NULL,

        CONSTRAINT FK_Requests_Status
            FOREIGN KEY (StatusId) REFERENCES dbo.RequestStatus(StatusId),

        CONSTRAINT CK_Requests_Priority
            CHECK (Priority BETWEEN 1 AND 3)
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.RequestStatus)
BEGIN
    INSERT INTO dbo.RequestStatus (StatusId, StatusName)
    VALUES
        (1, N'Новая'),
        (2, N'В работе'),
        (3, N'Закрыта');
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'webuser'
)
BEGIN
    CREATE USER webuser FOR LOGIN webuser;
END
GO

ALTER ROLE db_datareader ADD MEMBER webuser;
ALTER ROLE db_datawriter ADD MEMBER webuser;
GO

INSERT INTO dbo.Requests (EmployeeName, Department, Title, Description, Priority, StatusId)
VALUES
(N'Иванов И.И.', N'ИТ', N'Не работает почта',
 N'Пользователь не может войти в почтовый ящик.', 1, 1),
(N'Петрова А.С.', N'HR', N'Справка о доходах',
 N'Нужна справка для банка.', 2, 1);
GO
CREATE TABLE [dbo].[CapitalDept] (
    [CAPITAL_DEPT_ID]    INT          IDENTITY (1, 1) NOT NULL,
    [COID]               VARCHAR (5)  NOT NULL,
    [DEPT_NUMBER]        INT          NOT NULL,
    [NAME]               VARCHAR (50) NOT NULL,
    [CREATE_DATE]        DATETIME     CONSTRAINT [DF_CapitalDept_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID] INT          NOT NULL,
    [UPDATE_DATE]        DATETIME     NULL,
    [UPDATED_BY_USER_ID] INT          NULL,
    CONSTRAINT [PK_CapitalDept] PRIMARY KEY CLUSTERED ([CAPITAL_DEPT_ID] ASC),
    CONSTRAINT [FK_CapitalDept_CapitalDept1] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_CapitalDept_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_CapitalDept_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);


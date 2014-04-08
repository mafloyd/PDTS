CREATE TABLE [dbo].[NurseDepartment] (
    [NURSE_DEPT_ID]      INT          IDENTITY (1, 1) NOT NULL,
    [DEPT_NUMBER]        INT          NOT NULL,
    [NAME]               VARCHAR (50) NOT NULL,
    [CREATE_DATE]        DATETIME     CONSTRAINT [DF_NurseDepartment_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID] INT          NOT NULL,
    [UPDATE_DATE]        DATETIME     NULL,
    [UPDATED_BY_USER_ID] INT          NULL,
    CONSTRAINT [PK_NurseDepartment] PRIMARY KEY CLUSTERED ([NURSE_DEPT_ID] ASC),
    CONSTRAINT [FK_NurseDepartment_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_NurseDepartment_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);


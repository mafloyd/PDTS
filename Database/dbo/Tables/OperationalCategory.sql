CREATE TABLE [dbo].[OperationalCategory] (
    [OPERATIONAL_CATEGORY_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                    VARCHAR (50) NOT NULL,
    [CREATE_DATE]             DATETIME     CONSTRAINT [DF_OperationalCategory_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]      INT          NOT NULL,
    [UPDATE_DATE]             DATETIME     NULL,
    [UPDATED_BY_USER_ID]      INT          NULL,
    CONSTRAINT [PK_OperationalCategory] PRIMARY KEY CLUSTERED ([OPERATIONAL_CATEGORY_ID] ASC),
    CONSTRAINT [FK_OperationalCategory_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_OperationalCategory_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);


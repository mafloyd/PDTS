CREATE TABLE [dbo].[User_Division_Xref] (
    [USER_DIVISION_XREF_ID] INT      IDENTITY (1, 1) NOT NULL,
    [USER_ID]               INT      NOT NULL,
    [DIVISION_ID]           INT      NOT NULL,
    [ACTIVE]                BIT      CONSTRAINT [DF_User_Division_Xref_ACTIVE] DEFAULT ((1)) NOT NULL,
    [CREATE_DATE]           DATETIME NOT NULL,
    [CREATED_BY_USER_ID]    INT      NOT NULL,
    [UPDATE_DATE]           DATETIME NULL,
    [UPDATED_BY_USER_ID]    INT      NULL,
    CONSTRAINT [PK_User_Division_Xref] PRIMARY KEY CLUSTERED ([USER_DIVISION_XREF_ID] ASC),
    CONSTRAINT [FK_User_Division_Xref_Division] FOREIGN KEY ([DIVISION_ID]) REFERENCES [dbo].[Division] ([DIVISION_ID]),
    CONSTRAINT [FK_User_Division_Xref_PdtsUser] FOREIGN KEY ([USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_User_Division_Xref_PdtsUser1] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_User_Division_Xref_PdtsUser2] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);


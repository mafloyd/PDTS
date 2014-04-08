CREATE TABLE [dbo].[User_Module_Xref] (
    [USER_MODULE_XREF_ID] INT IDENTITY (1, 1) NOT NULL,
    [USER_ID]             INT NOT NULL,
    [MODULE_ID]           INT NOT NULL,
    [ACTIVE]              BIT CONSTRAINT [DF_User_Module_Xref_ACTIVE] DEFAULT ((0)) NOT NULL,
    [ADMIN]               BIT CONSTRAINT [DF_User_Module_Xref_ADMIN] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_User_Module_Xref] PRIMARY KEY CLUSTERED ([USER_MODULE_XREF_ID] ASC),
    CONSTRAINT [FK_User_Module_Xref_Modules] FOREIGN KEY ([MODULE_ID]) REFERENCES [dbo].[Modules] ([MODULE_ID]),
    CONSTRAINT [FK_User_Module_Xref_PdtsUser] FOREIGN KEY ([USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);


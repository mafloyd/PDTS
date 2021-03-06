﻿CREATE TABLE [dbo].[Category] (
    [CATEGORY_ID]        INT          NOT NULL,
    [SHORT_NAME]         VARCHAR (20) NOT NULL,
    [LONG_NAME]          VARCHAR (50) NOT NULL,
    [CREATE_DATE]        DATETIME     CONSTRAINT [DF_Category_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID] INT          NOT NULL,
    [UPDATE_DATE]        DATETIME     NULL,
    [UPDATED_BY_USER_ID] INT          NULL,
    CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED ([CATEGORY_ID] ASC),
    CONSTRAINT [FK_Category_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_Category_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);


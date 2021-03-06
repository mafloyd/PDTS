﻿CREATE TABLE [dbo].[State] (
    [STATE_ID]           INT          NOT NULL,
    [SHORT_NAME]         VARCHAR (20) NOT NULL,
    [LONG_NAME]          VARCHAR (50) NOT NULL,
    [CREATE_DATE]        DATETIME     CONSTRAINT [DF_State_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID] INT          NOT NULL,
    [UPDATE_DATE]        DATETIME     NULL,
    [UPDATED_BY_USER_ID] INT          NULL,
    CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED ([STATE_ID] ASC),
    CONSTRAINT [FK_State_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_State_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);


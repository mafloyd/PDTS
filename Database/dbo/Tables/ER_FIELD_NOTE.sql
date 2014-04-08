﻿CREATE TABLE [dbo].[ER_FIELD_NOTE] (
    [ER_FIELD_NOTES_ID]  INT           IDENTITY (1, 1) NOT NULL,
    [COID]               VARCHAR (5)   NOT NULL,
    [MONTH]              INT           NOT NULL,
    [DAY]                INT           NOT NULL,
    [YEAR]               INT           NOT NULL,
    [NOTE]               VARCHAR (500) NOT NULL,
    [CREATE_DATE]        DATETIME      CONSTRAINT [DF_ER_FIELD_NOTE_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID] INT           NOT NULL,
    [UPDATE_DATE]        DATETIME      NULL,
    [UPDATED_BY_USER_ID] INT           NULL,
    CONSTRAINT [PK_ER_FIELD_NOTE] PRIMARY KEY CLUSTERED ([ER_FIELD_NOTES_ID] ASC),
    CONSTRAINT [FK_ER_FIELD_NOTE_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ER_FIELD_NOTE_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_ER_FIELD_NOTE_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);


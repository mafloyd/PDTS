﻿CREATE TABLE [dbo].[ig_Worksheet_NoteTypes] (
    [WS_NOTE_TYPE_ID]   INT          IDENTITY (1, 1) NOT NULL,
    [WS_NOTE_TYPE_DESC] VARCHAR (50) NULL,
    CONSTRAINT [PK_igWorksheetNoteTypes] PRIMARY KEY CLUSTERED ([WS_NOTE_TYPE_ID] ASC)
);


﻿CREATE TABLE [dbo].[SURVEY_QUESTION_TARGET] (
    [SURVEY_QUESTION_TARGET_ID] INT            IDENTITY (1, 1) NOT NULL,
    [COID]                      VARCHAR (5)    NOT NULL,
    [QUESTION_ID]               INT            NOT NULL,
    [TARGET]                    DECIMAL (4, 2) NOT NULL,
    [YEAR]                      INT            NOT NULL,
    CONSTRAINT [PK_SURVERY_QUESTION_TARGET] PRIMARY KEY CLUSTERED ([SURVEY_QUESTION_TARGET_ID] ASC),
    CONSTRAINT [FK_SURVERY_QUESTION_TARGET_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_SURVERY_QUESTION_TARGET_SURVEY_QUESTION] FOREIGN KEY ([QUESTION_ID]) REFERENCES [dbo].[SURVEY_QUESTION] ([QUESTION_ID])
);


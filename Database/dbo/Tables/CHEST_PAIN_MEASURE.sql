﻿CREATE TABLE [dbo].[CHEST_PAIN_MEASURE] (
    [CHEST_PAIN_MEASURE_ID] INT           IDENTITY (1, 1) NOT NULL,
    [NAME]                  VARCHAR (75)  NOT NULL,
    [COLUMN1]               VARCHAR (128) NOT NULL,
    [COLUMN2]               VARCHAR (128) NOT NULL,
    [IS_SPECIAL_CASE]       BIT           CONSTRAINT [DF_CHEST_PAIN_MEASURE_IS_SPECIAL_CASE] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CHEST_PAIN_MEAURE] PRIMARY KEY CLUSTERED ([CHEST_PAIN_MEASURE_ID] ASC)
);


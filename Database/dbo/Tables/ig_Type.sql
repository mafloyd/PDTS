﻿CREATE TABLE [dbo].[ig_Type] (
    [IGTYPE_ID]   INT          IDENTITY (1, 1) NOT NULL,
    [IGTYPE_DESC] VARCHAR (50) NULL,
    CONSTRAINT [PK_igType] PRIMARY KEY CLUSTERED ([IGTYPE_ID] ASC)
);

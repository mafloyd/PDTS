﻿CREATE TABLE [dbo].[ig_MGMACompType] (
    [MGMACOMPTYPE_ID]   INT          IDENTITY (1, 1) NOT NULL,
    [MGMACOMPTYPE_DESC] VARCHAR (50) NULL,
    CONSTRAINT [PK_igMGMACompType] PRIMARY KEY CLUSTERED ([MGMACOMPTYPE_ID] ASC)
);


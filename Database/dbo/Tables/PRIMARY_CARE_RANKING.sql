﻿CREATE TABLE [dbo].[PRIMARY_CARE_RANKING] (
    [PRIMARY_CARE_RANKING_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                    VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_PRIMARY_CARE_RANKIN] PRIMARY KEY CLUSTERED ([PRIMARY_CARE_RANKING_ID] ASC)
);


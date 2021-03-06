﻿CREATE TABLE [dbo].[PRIMARY_CARE_COMMUNITY_ACCEPTANCE] (
    [PRIMARY_CARE_COMMUNITY_ACCEPTANCE_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                                 VARCHAR (50) NOT NULL,
    [SCORE]                                TINYINT      CONSTRAINT [DF_PRIMARY_CARE_COMMUNITY_ACCEPTANCE_SCORE] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_PRIMARY_CARE_COMMUNITY_ACCEPTANCE] PRIMARY KEY CLUSTERED ([PRIMARY_CARE_COMMUNITY_ACCEPTANCE_ID] ASC)
);


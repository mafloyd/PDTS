﻿CREATE TABLE [dbo].[ProjectedAdmits] (
    [PROJECTED_ADMIT_ID] INT      IDENTITY (1, 1) NOT NULL,
    [PDTS_PROVIDER_ID]   INT      NOT NULL,
    [YEAR]               INT      NOT NULL,
    [PERIOD9_ADMITS]     INT      NOT NULL,
    [PERIOD10_ADMITS]    INT      NOT NULL,
    [PERIOD11_ADMITS]    INT      NOT NULL,
    [PERIOD12_ADMITS]    INT      NOT NULL,
    [CREATE_DATE]        DATETIME CONSTRAINT [DF_ProjectedAdmits_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID] INT      NOT NULL,
    [UPDATE_DATE]        DATETIME NULL,
    [UPDATED_BY_USER_ID] INT      NULL,
    CONSTRAINT [PK_ProjectedAdmits] PRIMARY KEY CLUSTERED ([PROJECTED_ADMIT_ID] ASC),
    CONSTRAINT [FK_ProjectedAdmits_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProjectedAdmits_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProjectedAdmits_Provider] FOREIGN KEY ([PDTS_PROVIDER_ID]) REFERENCES [dbo].[Provider] ([PDTS_PROVIDER_ID]) ON DELETE CASCADE
);

﻿CREATE TABLE [dbo].[OP_IMAGING_FOLLOWUP_PHY_NOTIFY] (
    [OP_IMAGING_FOLLOWUP_PHY_NOTIFY_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                              VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_OP_IMAGING_FOLLOWUP_PHY_NOTIFIY] PRIMARY KEY CLUSTERED ([OP_IMAGING_FOLLOWUP_PHY_NOTIFY_ID] ASC)
);


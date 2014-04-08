﻿CREATE TABLE [dbo].[OP_IMAGING_FOLLOWUP_REACH_PATIENT] (
    [OP_IMAGING_FOLLOWUP_REACH_PATIENT_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                                 VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_OP_IMAGING_FOLLOWUP_REACH_PATIENT] PRIMARY KEY CLUSTERED ([OP_IMAGING_FOLLOWUP_REACH_PATIENT_ID] ASC)
);


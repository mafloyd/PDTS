﻿CREATE TABLE [dbo].[OP_IMAGING_FOLLOWUP_PATIENT_ATTEMPT] (
    [OP_IMAGING_FOLLOWUP_PATIENT_ATTEMPT_ID] INT      IDENTITY (1, 1) NOT NULL,
    [OP_IMAGING_FOLLOWUP_PATIENT_ID]         INT      NOT NULL,
    [OP_IMAGING_FOLLOWUP_REACH_PATIENT_ID]   INT      NOT NULL,
    [ATTEMPT_DATE]                           DATETIME NOT NULL,
    [CREATE_DATE]                            DATETIME CONSTRAINT [DF_OP_IMAGING_FOLLOWUP_PATIENT_ATTEMPT_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]                     INT      NOT NULL,
    [UPDATE_DATE]                            DATETIME NULL,
    [UPDATED_BY_USER_ID]                     INT      NULL,
    CONSTRAINT [PK_OP_IMAGING_FOLLOWUP_PATIENT_ATTEMPT] PRIMARY KEY CLUSTERED ([OP_IMAGING_FOLLOWUP_PATIENT_ATTEMPT_ID] ASC),
    CONSTRAINT [FK_OP_IMAGING_FOLLOWUP_PATIENT_ATTEMPT_OP_IMAGING_FOLLOWUP_PATIENT] FOREIGN KEY ([OP_IMAGING_FOLLOWUP_PATIENT_ID]) REFERENCES [dbo].[OP_IMAGING_FOLLOWUP_PATIENT] ([OP_IMAGING_FOLLOWUP_PATIENT_ID]),
    CONSTRAINT [FK_OP_IMAGING_FOLLOWUP_PATIENT_ATTEMPT_OP_IMAGING_FOLLOWUP_REACH_PATIENT] FOREIGN KEY ([OP_IMAGING_FOLLOWUP_REACH_PATIENT_ID]) REFERENCES [dbo].[OP_IMAGING_FOLLOWUP_REACH_PATIENT] ([OP_IMAGING_FOLLOWUP_REACH_PATIENT_ID]),
    CONSTRAINT [FK_OP_IMAGING_FOLLOWUP_PATIENT_ATTEMPT_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_OP_IMAGING_FOLLOWUP_PATIENT_ATTEMPT_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);


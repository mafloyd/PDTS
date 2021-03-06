﻿CREATE TABLE [dbo].[OP_IMAGING_FOLLOWUP_PATIENT] (
    [OP_IMAGING_FOLLOWUP_PATIENT_ID]       INT           IDENTITY (1, 1) NOT NULL,
    [COID]                                 VARCHAR (5)   NOT NULL,
    [FIRST_NAME]                           VARCHAR (50)  NULL,
    [LAST_NAME]                            VARCHAR (50)  NULL,
    [ACCOUNT_NUMBER]                       VARCHAR (50)  NULL,
    [APPOINTMENT_DATE]                     DATETIME      NULL,
    [TELEPHONE_1]                          VARCHAR (10)  NULL,
    [TELEPHONE_2]                          VARCHAR (10)  NULL,
    [OP_PROCEDURE]                         VARCHAR (100) NULL,
    [GENDER]                               CHAR (1)      NULL,
    [ABLE_TO_RESCHEDULE]                   BIT           CONSTRAINT [DF_OP_IMAGING_PATIENT_ABLE_TO_RESCHEDULE] DEFAULT ((0)) NOT NULL,
    [OP_IMAGING_FOLLOWUP_UNABLE_REASON_ID] INT           NULL,
    [CREATED_BY_USER_ID]                   INT           NOT NULL,
    [CREATE_DATE]                          DATETIME      CONSTRAINT [DF_OP_IMAGING_PATIENT_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [UPDATED_BY_USER_ID]                   INT           NULL,
    [UPDATE_DATE]                          DATETIME      NULL,
    [REFERRING_PHYSICIAN_NAME]             VARCHAR (100) NULL,
    [REFERRING_PHYSICIAN_PHONE]            VARCHAR (10)  NULL,
    [OP_IMAGING_FOLLOWUP_PHY_NOTIFY_ID]    INT           NULL,
    [RESCHEDULE_DATE]                      DATETIME      NULL,
    [IS_VISIBLE_FOR_UI]                    BIT           CONSTRAINT [DF_OP_IMAGING_FOLLOWUP_PATIENT_IS_VISIBLE_FOR_UI] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_OP_IMAGING_PATIENT] PRIMARY KEY CLUSTERED ([OP_IMAGING_FOLLOWUP_PATIENT_ID] ASC),
    CONSTRAINT [FK_OP_IMAGING_FOLLOWUP_PATIENT_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_OP_IMAGING_FOLLOWUP_PATIENT_OP_IMAGING_FOLLOWUP_PHY_NOTIFY] FOREIGN KEY ([OP_IMAGING_FOLLOWUP_PHY_NOTIFY_ID]) REFERENCES [dbo].[OP_IMAGING_FOLLOWUP_PHY_NOTIFY] ([OP_IMAGING_FOLLOWUP_PHY_NOTIFY_ID]),
    CONSTRAINT [FK_OP_IMAGING_PATIENT_OP_IMAGING_UNABLE_REASON] FOREIGN KEY ([OP_IMAGING_FOLLOWUP_UNABLE_REASON_ID]) REFERENCES [dbo].[OP_IMAGING_FOLLOWUP_UNABLE_REASON] ([OP_IMAGING_FOLLOWUP_UNABLE_REASON_ID]),
    CONSTRAINT [FK_OP_IMAGING_PATIENT_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_OP_IMAGING_PATIENT_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);


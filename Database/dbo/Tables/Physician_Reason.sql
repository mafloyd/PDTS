CREATE TABLE [dbo].[Physician_Reason] (
    [PHYSICIAN_REASON_ID] INT          IDENTITY (1, 1) NOT NULL,
    [SHORT_NAME]          VARCHAR (20) NOT NULL,
    [LONG_NAME]           VARCHAR (50) NOT NULL,
    [CREATE_DATE]         DATETIME     CONSTRAINT [DF_Physician_Reason_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]  INT          NOT NULL,
    [UPDATE_DATE]         DATETIME     NULL,
    [UPDATED_BY_USER_ID]  INT          NULL,
    CONSTRAINT [PK_Physician_Reason] PRIMARY KEY CLUSTERED ([PHYSICIAN_REASON_ID] ASC),
    CONSTRAINT [FK_Physician_Reason_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_Physician_Reason_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);


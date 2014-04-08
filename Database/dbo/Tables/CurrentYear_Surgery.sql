CREATE TABLE [dbo].[CurrentYear_Surgery] (
    [CURRENTYEAR_SURGERY_ID] INT      IDENTITY (1, 1) NOT NULL,
    [PDTS_PROVIDER_ID]       INT      NOT NULL,
    [SURGICAL_TYPE_ID]       INT      NOT NULL,
    [MONTHNO]                TINYINT  NOT NULL,
    [YEAR]                   SMALLINT NOT NULL,
    [INPATIENT]              INT      NOT NULL,
    [OUTPATIENT]             INT      NOT NULL,
    [CREATE_DATE]            DATETIME CONSTRAINT [DF_CurrentYear_Surgery_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]     INT      NOT NULL,
    [UPDATE_DATE]            DATETIME NULL,
    [UPDATED_BY_USER_ID]     INT      NULL,
    CONSTRAINT [PK_CurrentYear_Surgery] PRIMARY KEY CLUSTERED ([CURRENTYEAR_SURGERY_ID] ASC),
    CONSTRAINT [FK_CurrentYear_Surgery_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_CurrentYear_Surgery_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_CurrentYear_Surgery_Provider] FOREIGN KEY ([PDTS_PROVIDER_ID]) REFERENCES [dbo].[Provider] ([PDTS_PROVIDER_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_CurrentYear_Surgery_Surgical_Type] FOREIGN KEY ([SURGICAL_TYPE_ID]) REFERENCES [dbo].[Surgical_Type] ([SURGICAL_TYPE_ID])
);


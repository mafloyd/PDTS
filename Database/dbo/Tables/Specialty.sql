CREATE TABLE [dbo].[Specialty] (
    [SPECIALTY_ID]                INT          IDENTITY (1, 1) NOT NULL,
    [SHORT_NAME]                  VARCHAR (20) NOT NULL,
    [LONG_NAME]                   VARCHAR (50) NOT NULL,
    [ADMITTING]                   BIT          NOT NULL,
    [CREATE_DATE]                 DATETIME     CONSTRAINT [DF_Specialty_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]          INT          NOT NULL,
    [UPDATE_DATE]                 DATETIME     NULL,
    [UPDATED_BY_USER_ID]          INT          NULL,
    [SPECIALTY_GROUP_ID]          INT          NULL,
    [SPECIALTY_GROP_TOP_LEVEL_ID] INT          NULL,
    CONSTRAINT [PK_Specialty] PRIMARY KEY CLUSTERED ([SPECIALTY_ID] ASC),
    CONSTRAINT [FK_Specialty_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_Specialty_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_Specialty_Specialty] FOREIGN KEY ([SPECIALTY_ID]) REFERENCES [dbo].[Specialty] ([SPECIALTY_ID]),
    CONSTRAINT [FK_Specialty_SPECIALTY_GROUP_TOP_LEVEL] FOREIGN KEY ([SPECIALTY_GROP_TOP_LEVEL_ID]) REFERENCES [dbo].[SPECIALTY_GROUP_TOP_LEVEL] ([SPECIALTY_GROUP_TOP_LEVEL_ID]),
    CONSTRAINT [FK_Specialty_SpecialtyGroup] FOREIGN KEY ([SPECIALTY_GROUP_ID]) REFERENCES [dbo].[SpecialtyGroup] ([SPECIALTY_GROUP_ID])
);


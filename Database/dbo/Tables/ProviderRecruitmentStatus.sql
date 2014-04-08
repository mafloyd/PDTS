CREATE TABLE [dbo].[ProviderRecruitmentStatus] (
    [PROVIDER_RECRUITMENT_STATUS_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                           VARCHAR (50) NOT NULL,
    [CREATE_DATE]                    DATETIME     CONSTRAINT [DF_ProviderRecruitmentStatus_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]             INT          NOT NULL,
    [UPDATE_DATE]                    DATETIME     NULL,
    [UPDATED_BY_USER_ID]             INT          NULL,
    CONSTRAINT [PK_ProviderRecruitmentStatus] PRIMARY KEY CLUSTERED ([PROVIDER_RECRUITMENT_STATUS_ID] ASC),
    CONSTRAINT [FK_ProviderRecruitmentStatus_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProviderRecruitmentStatus_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);


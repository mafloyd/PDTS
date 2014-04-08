CREATE TABLE [dbo].[PCR_ALL_COIDS] (
    [LEVEL6]           NVARCHAR (6)   NULL,
    [AA4_CO_ID]        NVARCHAR (6)   NULL,
    [AA4_CO_ID_DESC]   NVARCHAR (150) NULL,
    [AA5_ACCOUNT]      INT            NULL,
    [AA5_ACCOUNT_DESC] NVARCHAR (150) NULL,
    [AA6_FS_CODE]      INT            NULL,
    [AA6_FS_CODE_DESC] NVARCHAR (150) NULL,
    [GLBalance]        MONEY          NULL,
    [MONTH]            SMALLINT       NULL,
    [YEAR]             SMALLINT       NULL,
    [ID]               INT            NOT NULL,
    [CreateDate]       DATETIME       NULL,
    [Type]             INT            NULL
);


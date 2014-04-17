﻿CREATE TABLE [dbo].[PCR_FSCODE_FILTER] (
    [PCR_FILTER_ID]       INT           IDENTITY (1, 1) NOT NULL,
    [FS_CODE]             INT           NOT NULL,
    [FS_CODE_DESCRIPTION] VARCHAR (100) NOT NULL,
    [IS_PRE]              BIT           CONSTRAINT [DF_PCR_FSCODE_FILTER_IS_PRE] DEFAULT ((0)) NOT NULL,
    [IS_POST]             BIT           CONSTRAINT [DF_PCR_FSCODE_FILTER_IS_POST] DEFAULT ((0)) NOT NULL,
    [ACTIVE]              BIT           CONSTRAINT [DF_PCR_FSCODE_FILTER_ACTIVE] DEFAULT ((0)) NOT NULL,
    [CREATE_DATE]         DATETIME      CONSTRAINT [DF_PCR_FSCODE_FILTER_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]  INT           NOT NULL,
    [UPDATE_DATE]         DATETIME      NULL,
    [UPDATED_BY_USER_ID]  INT           NULL,
    [IS_COMMENT_REQUIRED] BIT           CONSTRAINT [DF_PCR_FSCODE_FILTER_IS_COMMENT_REQUIRED] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_PCR_FSCODE_FILTER] PRIMARY KEY CLUSTERED ([PCR_FILTER_ID] ASC)
);


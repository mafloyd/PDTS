﻿CREATE TABLE [dbo].[LIFEPOINT_HOSPITAL_MANAGEMENT_SYSTEM] (
    [LIFEPOINT_HOSPITAL_MANAGEMENT_SYSTEM_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                                    VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_LIFEPOINT_HOSPITAL_MANAGEMENT_SYSTEM] PRIMARY KEY CLUSTERED ([LIFEPOINT_HOSPITAL_MANAGEMENT_SYSTEM_ID] ASC)
);


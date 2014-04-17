﻿CREATE TABLE [dbo].[OP_IMAGING_DASHBOARD_ORDER_TYPE_CROSSWALK] (
    [OP_IMAGING_DASHBOARD_ORDER_TYPE_CROSSWALK_ID] INT          IDENTITY (1, 1) NOT NULL,
    [SOURCE_TYPE]                                  VARCHAR (50) NOT NULL,
    [OP_ORDER_TYPE_ID]                             INT          NULL,
    [IMPORT]                                       BIT          CONSTRAINT [DF_OP_IMAGING_DASHBOARD_ORDER_TYPE_CROSSWALK_IMPORT] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_OP_IMAGING_DASHBOARD_ORDER_TYPE_CROSSWALK] PRIMARY KEY CLUSTERED ([OP_IMAGING_DASHBOARD_ORDER_TYPE_CROSSWALK_ID] ASC),
    CONSTRAINT [FK_OP_IMAGING_DASHBOARD_ORDER_TYPE_CROSSWALK_OP_ORDER_TYPE] FOREIGN KEY ([OP_ORDER_TYPE_ID]) REFERENCES [dbo].[OP_ORDER_TYPE] ([OP_ORDER_TYPE_ID])
);

﻿CREATE TABLE [dbo].[OP_IMAGING_DASHBOARD] (
    [OP_IMAGING_DASHBOARD_ID] INT           IDENTITY (1, 1) NOT NULL,
    [COID]                    VARCHAR (5)   NOT NULL,
    [PAT_NUM]                 VARCHAR (50)  NULL,
    [OP_ORDER_TYPE_ID]        INT           NULL,
    [ORDER_DESCRIPTION]       VARCHAR (100) NULL,
    [ARRIVAL]                 DATETIME      NULL,
    [REGISTRATION_START]      DATETIME      NULL,
    [REGISTRATION_END]        DATETIME      NULL,
    [EXAM_START]              DATETIME      NULL,
    [EXAM_END]                DATETIME      NULL,
    [PRELIM_REPORT]           DATETIME      NULL,
    [FINAL_REPORT]            DATETIME      NULL,
    [INCLUDED]                BIT           CONSTRAINT [DF_OP_IMAGING_DASHBOARD_INCLUDED] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_OP_IMAGING_DASHBOARD] PRIMARY KEY CLUSTERED ([OP_IMAGING_DASHBOARD_ID] ASC),
    CONSTRAINT [FK_OP_IMAGING_DASHBOARD_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_OP_IMAGING_DASHBOARD_OP_ORDER_TYPE] FOREIGN KEY ([OP_ORDER_TYPE_ID]) REFERENCES [dbo].[OP_ORDER_TYPE] ([OP_ORDER_TYPE_ID])
);

